<<<<<<< HEAD
resource "oci_core_instance" "TEST-Comp-Inst" {
  depends_on          = [oci_file_storage_mount_target.my_mount_target_1]
  count               = 2
  compartment_id      = var.oci_compartment
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
  shape               = "VM.Standard.E2.4" #"VM.Standard2.1"  #"VM.Standard.E2.2"
  source_details {
    source_id   = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa47555lp4mjbiuf64doxtnbimrwk57m4sfgu3gonaf5i2cteil5iq"
    source_type = "image"
  }

  display_name = "${var.display_name}-${count.index + 1}"
  create_vnic_details {
    assign_public_ip = false
    subnet_id        = oci_core_subnet.Bastion_subnet[count.index].id
  }
  metadata = {
    user_data           = base64encode(var.user-data)
    ssh_authorized_keys = var.session_key_details_public_key_content
  }

  timeouts {
    create = "60m"
  }
  preserve_boot_volume = false
  agent_config {
    are_all_plugins_disabled = false
    is_management_disabled   = false
    is_monitoring_disabled   = false
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
=======
resource "oci_core_instance" "TEST-Comp-Inst"  {
    depends_on = [oci_file_storage_mount_target.my_mount_target_1]
    count               =  2
    compartment_id = var.oci_compartment
    availability_domain   = "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
    shape = "VM.Standard.E2.4"      #"VM.Standard2.1"  #"VM.Standard.E2.2"
    source_details {
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa47555lp4mjbiuf64doxtnbimrwk57m4sfgu3gonaf5i2cteil5iq"
        source_type = "image"
  }

    display_name          = "${var.display_name}-${count.index + 1}"
    create_vnic_details {
        assign_public_ip = false
        subnet_id             = oci_core_subnet.Bastion_subnet[count.index].id
 } 
    metadata = {
      user_data = base64encode(var.user-data)
      ssh_authorized_keys = var.session_key_details_public_key_content
  }

    timeouts {
       create = "60m"
}
    preserve_boot_volume = false
    agent_config {
    are_all_plugins_disabled = false
    is_management_disabled = false
    is_monitoring_disabled = false
    plugins_config {
    desired_state = "ENABLED" 
    name = "Bastion"
}
}
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
}
variable "user-data" {
  default = <<EOF
#!/bin/bash -x
echo '################### webserver userdata begins #####################'
touch ~opc/userdata.`date +%s`.start
# echo '########## yum update all ###############'
# yum update -y
echo '########## basic webserver ##############'
yum install -y httpd
systemctl enable  httpd.service
systemctl start  httpd.service
echo '<html><head></head><body><pre><code>' > /var/www/html/index.html
hostname >> /var/www/html/index.html
echo '' >> /var/www/html/index.html
cat /etc/os-release >> /var/www/html/index.html
echo '</code></pre></body></html>' >> /var/www/html/index.html
firewall-offline-cmd --add-service=http
systemctl enable  firewalld
systemctl restart  firewalld
touch ~opc/userdata.`date +%s`.finish
echo '################### webserver userdata ends #######################'
sleep 10
sudo mkdir -p /mnt/nfs 
sudo mount 10.0.2.210:/example_path /mnt/nfs

EOF
}
