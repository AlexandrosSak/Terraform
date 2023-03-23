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
default = "ssh-rsa ......"
}

variable "display_name" {
  default = "Private_Instance"
  type = string
}
