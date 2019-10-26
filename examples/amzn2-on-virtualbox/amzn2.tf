module "amzn2" {
  source = "../../"

  vm_name  = var.vm_name
  vdi      = var.vdi
  userdata = var.userdata

}
