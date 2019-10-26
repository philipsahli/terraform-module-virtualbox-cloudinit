data "template_file" "metadata" {
  count    = var.vm_count
  template = "${file("${path.module}/files/meta-data.tpl")}"
  vars = {
    hostname   = "${var.vm_name}${count.index}"
    instanceId = "${count.index}"
  }
}

resource "local_file" "metadata" {
  count    = var.vm_count
  content  = data.template_file.metadata.*.rendered[count.index]
  filename = "${path.cwd}/${var.vm_name}${count.index}/meta-data"
}

resource "local_file" "userdata" {
  count    = var.vm_count
  content  = var.userdata
  filename = "${path.cwd}/${var.vm_name}${count.index}/user-data"
}