variable "oci_tenancy" {} 
variable "oci_user" {}
variable "oci_fingerprint" {}
variable "oci_key" {}
variable "oci_region" {}
variable "oci_compartment" {}
variable "private_key_file" {}
variable "public_key" {}
variable "bastion_name" {
 default = "Bastion"
}
variable "bastion_defined_tags_value" {
  default = "value"
}
variable "bastion_client_cidr_block_allow_list" {
  default = ["0.0.0.0/0"]
}
variable "bastion_bastion_lifecycle_state" {
  default = "ACTIVE"
}
variable "bastion_max_session_ttl_in_seconds" {
  default = 1800
}
variable "bastion_freeform_tags" {
  default = {
    "bar-key" = "bastion_test"
  }
}
variable "session_key_type" {
  default = "PUB"
}
variable "session_target_resource_details_target_resource_port" {
  default = 22
}
variable "session_target_resource_details_session_type_managed_ssh" {
default = "MANAGED_SSH"
}
variable "session_display_name" {
default = "bastionSessionExample"
}
variable "session_session_ttl_in_seconds" {
default = 3600
}

variable "session_key_details_public_key_content" {
default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyyaoTwIoO6oIPWcVaL0WcCoiPPCqTFimiGEZiLWTY/wfHKhCgwB19qnMC0tDiYiFnn0BnQlvhQTlg6D4j+kxG8Kwvg8WZ78OcyNQ56ML75wI5EOXivzTuIPEaVY47yMIPHvb4FOHZT+1am9s//aI7gZwjdpLFAPLnoxa7znsv1gysmgimx4yF6QUE9FfaFH+q51Q5xA3k/DWvIGww7nroOs+3K/qTMFmOFaPxgbI4wp+mRgmHzeuJrTh629IOOTzFfLc8oD9Mo+nhMBFqnC4RqyAcra1RrfxE7UwmonA5HWKwQwekPEtItLenhEbEU54odZ2lI/wSyaQAVNqsDYBnKU1j+7AbkXik1qjH+GoDkSFgLZLd09QdD19uGvOs1bH5/2OE2uLBulTfIMuzfx1B05kRxL1o/Vb7S/0oeMdwRj200Pgd+aR6aMzIQ0fG8WrerdP+pI1mZWv/fi6w551WkFsAWHMiH9UtLoYe9vH68dI3FF01bH+l51irjKV20ZM= opc@test-instance-20230117-1615"
}

variable "display_name" {
  default = "Private_Instance"
  type = string
}
