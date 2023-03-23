resource "time_sleep" "wait_3_minutes_for_bastion_plugin" {
  depends_on      = [oci_core_instance.TEST-Comp-Inst[0], oci_core_instance.TEST-Comp-Inst[1]]
  create_duration = "4m"
}

resource "oci_bastion_bastion" "test_bastion" {
  bastion_type     = "STANDARD"
  compartment_id   = var.oci_compartment
  target_subnet_id = oci_core_subnet.Bastion_subnet[0].id
  #target_subnet_id          = oci_core_subnet.Bastion_subnet[count.index].id      
  name                         = var.bastion_name #"${var.bastion_name}_${count.index + 1}"
  freeform_tags                = var.bastion_freeform_tags
  client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
  max_session_ttl_in_seconds   = var.bastion_max_session_ttl_in_seconds
}
resource "oci_bastion_session" "test_session_managed_ssh" {
  count      = 2
  bastion_id = oci_bastion_bastion.test_bastion.id
  key_details {
    public_key_content = var.session_key_details_public_key_content
  }

  target_resource_details {
    session_type                               = var.session_target_resource_details_session_type_managed_ssh
    target_resource_id                         = oci_core_instance.TEST-Comp-Inst[count.index].id
    target_resource_operating_system_user_name = "opc"
    target_resource_port                       = var.session_target_resource_details_target_resource_port
    target_resource_private_ip_address         = oci_core_instance.TEST-Comp-Inst[count.index].private_ip
  }

  display_name           = var.session_display_name
  key_type               = var.session_key_type
  session_ttl_in_seconds = var.session_session_ttl_in_seconds

  depends_on = [time_sleep.wait_3_minutes_for_bastion_plugin]
}


