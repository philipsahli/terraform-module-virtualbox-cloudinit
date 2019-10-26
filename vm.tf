resource "null_resource" "seediso2" {
  count       = var.vm_count
  provisioner "local-exec" {
    working_dir = path.cwd
    command = "hdiutil makehybrid -o seed${count.index}.iso -hfs -joliet -iso -default-volume-name cidata ${var.vm_name}${count.index}/"
  }

  provisioner "local-exec" {
    command = "rm -rf seed${count.index}.iso"
    when    = "destroy"
  }

  depends_on = [local_file.userdata, local_file.metadata]
}

resource "null_resource" "base_vdi" {
  provisioner "local-exec" {
    working_dir = path.cwd
    command     = "wget --continue -O ${var.vm_name}.vdi ${var.vdi}"
  }
}

resource "null_resource" "disk" {
  count = var.vm_count
  provisioner "local-exec" {
    working_dir = path.cwd
    command     = "cp ${var.vm_name}.vdi ${var.vm_name}${count.index}.vdi"
  }

  depends_on = [null_resource.base_vdi]
}

resource "null_resource" "vm" {
  count = var.vm_count
  provisioner "local-exec" {
    command = "VBoxManage createvm --name vm${count.index} --ostype \"Linux_64\" --register"
  }

  provisioner "local-exec" {
    command = "VBoxManage modifyvm vm${count.index} --memory 1024 --vram 128"
  }

  provisioner "local-exec" {
    when    = "destroy"
    command = "VBoxManage unregistervm vm${count.index} --delete"
  }

  depends_on = [null_resource.disk]
}

resource "null_resource" "controller_sata" {
  count = var.vm_count
  provisioner "local-exec" {
    command = "VBoxManage storagectl vm${count.index} --name \"SATA Controller\" --add sata --controller IntelAHCI"
  }
  depends_on = [null_resource.vm]
}

resource "null_resource" "controller_ide" {
  count = var.vm_count
  provisioner "local-exec" {
    command = "VBoxManage storagectl vm${count.index} --name \"IDE Controller\" --add ide --controller PIIX4"
  }
  depends_on = [
    null_resource.vm,
  ]
}

resource "null_resource" "storage_disk" {
  count = var.vm_count

  provisioner "local-exec" {
    working_dir = path.cwd
    command     = "VBoxManage internalcommands sethduuid vm${count.index}.vdi"
  }

  provisioner "local-exec" {
    working_dir = path.cwd
    command     = "VBoxManage storageattach vm${count.index} --storagectl 'SATA Controller' --port 0  --device 0 --type hdd --medium  vm${count.index}.vdi"
  }
  depends_on = [
    null_resource.controller_sata,
  ]
}

resource "null_resource" "storage_seed" {
  count = var.vm_count
  provisioner "local-exec" {
    working_dir = path.cwd
    command     = "VBoxManage storageattach vm${count.index} --storagectl \"IDE Controller\" --port 0 --device 0 --type dvddrive --medium seed${count.index}.iso"
  }
  depends_on = [
    null_resource.controller_ide,
  ]
}

resource "null_resource" "ssh_port" {
  count = var.vm_count
  provisioner "local-exec" {
    command = "VBoxManage modifyvm ${var.vm_name}${count.index} --natpf1 \"guestssh,tcp,,222${count.index},,22\""
  }
  depends_on = [null_resource.storage_seed]
}

resource "null_resource" "start" {
  count = var.vm_count
  provisioner "local-exec" {
    command = "VBoxManage startvm ${var.vm_name}${count.index}"
  }
  depends_on = [null_resource.ssh_port]
}



# VBoxManage internalcommands sethduuid