resource "oci_core_instance" "TEST-Comp-Inst_01" {
    availability_domain = "sgAm:EU-FRANKFURT-1-AD-1"
    compartment_id = var.oci_compartment
    shape = "VM.Standard.E2.4"      #"VM.Standard2.1"  #"VM.Standard.E2.2"
    #key_pair = oci_core_ssh_key.example_key_pair.private_key_openssh
    source_details {
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa47555lp4mjbiuf64doxtnbimrwk57m4sfgu3gonaf5i2cteil5iq"
        source_type = "image"
  }

    display_name = "my-terraform-vm_01"
    create_vnic_details {
        assign_public_ip = true

        subnet_id = oci_core_subnet.my_subnet_01.id
        
    metadata = {
      user_data = base64encode(var.user-data)
      ssh_authorized_keys = var.public_key
  }
    preserve_boot_volume = false
}


output "public_ip" {
  value = oci_core_instance.TEST-Comp-Inst_01.public_ip
}


resource "oci_core_instance" "TEST-Comp-Inst_2" {
    availability_domain = "sgAm:EU-FRANKFURT-1-AD-2"
    compartment_id = var.oci_compartment
    shape = "VM.Standard2.1"          #"VM.Standard.E2.2"
    source_details {
        source_id = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa47555lp4mjbiuf64doxtnbimrwk57m4sfgu3gonaf5i2cteil5iq"
        source_type = "image"
  }

    display_name = "my-terraform-vm_2"
    create_vnic_details {
        assign_public_ip = true
        subnet_id = oci_core_subnet.my_subnet_02.id 
  }
    metadata = {
      user_data = base64encode(var.user-data)
      ssh_authorized_keys = var.public_key
  }
    preserve_boot_volume = false
  }
output "public_ip_2" {
  value = oci_core_instance.TEST-Comp-Inst_2.public_ip
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
EOF
}
