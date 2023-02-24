resource "oci_bastion_bastion" "test_bastion" {
  #Required
  bastion_type                   = "STANDARD"
  compartment_id                 = var.oci_compartment
  target_subnet_id               = oci_core_subnet.my_subnet_01.id
  client_cidr_block_allow_list   = ["10.0.0.0/17"] 
}

