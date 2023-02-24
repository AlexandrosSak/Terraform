#####Create a block volume in OCI:
resource "oci_core_volume" "example_block_volume" {
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.oci_compartment
  display_name        = "example_block_volume"
  size_in_gbs         = "50"
}

####### Create an NFS file system :
resource "oci_file_storage_file_system" "example_file_system" {
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-1"
  compartment_id      = var.oci_compartment
  display_name        = "example_file_system"
}
####===================Mount Target=======================================
resource "oci_file_storage_mount_target" "my_mount_target_1" {
    #Required
    availability_domain = "sgAm:EU-FRANKFURT-1-AD-1"
    compartment_id = var.oci_compartment
    subnet_id = oci_core_subnet.my_subnet_01.id
    display_name = "my-mount-target-1"
    ip_address = "10.0.120.210"
}
####==================Export_set=============================================

resource "oci_file_storage_export_set" "my_export_set_1" {
    #Required
    mount_target_id = oci_file_storage_mount_target.my_mount_target_1.id
    max_fs_stat_bytes   = "53687091200"
    max_fs_stat_files   = "53687091200"
}

###### Attach the block volume to an NFS file system:
resource "oci_file_storage_export" "example_export" {
  export_set_id   = oci_file_storage_export_set.my_export_set_1.id
  file_system_id = oci_file_storage_file_system.example_file_system.id
  path            = "/example_path"
}
resource "oci_core_volume_attachment" "example_attachment" {
  instance_id         = "${oci_core_instance.TEST-Comp-Inst_01.id}"
  volume_id           = "${oci_core_volume.example_block_volume.id}"
  attachment_type     = "paravirtualized"
}


######## Mount the NFS file system on the instance===============================================

output "nfs_priv_ip" {
  value = oci_file_storage_mount_target.my_mount_target_1.ip_address 
}


resource "null_resource" "mount_nfs" {
   depends_on = [oci_file_storage_mount_target.my_mount_target_1]

 provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y &&",
      "sudo dnf install -y nfs-utils &&",
      "sudo mkdir -p /mnt/nfs &&",
      "sudo mount 10.0.120.210:/example_path /mnt/nfs"
    ]

    connection {
      type        = "ssh"
      user        = "opc"
      private_key = file("/home/opc/.ssh/id_rsa")
      host        = oci_core_instance.TEST-Comp-Inst_01.public_ip
    }
  }
}
