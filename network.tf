provider "oci" {
<<<<<<< HEAD
  tenancy_ocid     = var.oci_tenancy
  user_ocid        = var.oci_user
  fingerprint      = var.oci_fingerprint
  private_key_path = var.oci_key
  region           = var.oci_region
}

data "oci_core_services" "test_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
=======
  tenancy_ocid = var.oci_tenancy
  user_ocid = var.oci_user
  fingerprint = var.oci_fingerprint
  private_key_path = var.oci_key
  region = var.oci_region
}

data "oci_core_services" "test_services" {
filter {
  name = "name"
  values = ["All .* Services In Oracle Services Network"]
  regex = true
}
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
}
output "services" {
  value = [data.oci_core_services.test_services.services]
}

resource "oci_core_vcn" "my_vcn" {
<<<<<<< HEAD
  cidr_block     = "10.0.0.0/16"
  display_name   = "my_vcn"
  dns_label      = "examplevcn"
=======
  cidr_block = "10.0.0.0/16"
  display_name = "my_vcn"
  dns_label = "examplevcn"
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
  compartment_id = var.oci_compartment
}

resource "oci_core_security_list" "terraformsecuritylist" {
  display_name   = "terraformsecuritylist"
  compartment_id = oci_core_vcn.my_vcn.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id

<<<<<<< HEAD
  egress_security_rules {
=======
egress_security_rules {
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

<<<<<<< HEAD
  ingress_security_rules {
    description = "Allow SSH traffic"
    protocol    = "6"
    source      = "0.0.0.0/0"
  }
=======
ingress_security_rules {
    description     = "Allow SSH traffic"
    protocol        = "all"    
    source          = "0.0.0.0/0"
    }
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
}
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.oci_compartment
  vcn_id         = oci_core_vcn.my_vcn.id
  display_name   = "nat_gateway"
}
#resource "oci_core_service_gateway" "example" {
#  compartment_id = var.oci_compartment
#  vcn_id         = oci_core_vcn.my_vcn.id
#  display_name   = "example-service-gateway"
#  services {
#    service_id = data.oci_core_services.test_services.services[0]["id"]
#  }
#}

#data "oci_core_service_gateways" "test_service_gateways" {
<<<<<<< HEAD
#Required
#  compartment_id = var.oci_compartment

#Optional
=======
  #Required
#  compartment_id = var.oci_compartment

  #Optional
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
#  state  = "AVAILABLE"
#  vcn_id = oci_core_vcn.my_vcn.id
#}
#
#output "service_gateways" {
#  value = [data.oci_core_service_gateways.test_service_gateways.service_gateways]
#}


resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.my_vcn.default_route_table_id
  display_name               = "BastionRouteTable"
<<<<<<< HEAD
  route_rules {
    destination      = "0.0.0.0/0" #data.oci_core_services.test_services.services[0]["cidr_block"]
    destination_type = "CIDR_BLOCK"
    #network_entity_id = oci_core_service_gateway.example.id
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }
}
resource "oci_core_subnet" "Bastion_subnet" {
  count                      = 2
  availability_domain        = null #"sgAm:EU-FRANKFURT-1-AD-1"  # "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
  cidr_block                 = count.index == 0 ? "10.0.0.0/18" : "10.0.64.0/18"
  display_name               = "Private_subnet_0${count.index + 1}"
  vcn_id                     = oci_core_vcn.my_vcn.id
  compartment_id             = var.oci_compartment
  prohibit_public_ip_on_vnic = true
  security_list_ids          = [oci_core_security_list.terraformsecuritylist.id]
  route_table_id             = oci_core_vcn.my_vcn.default_route_table_id
  dhcp_options_id            = oci_core_vcn.my_vcn.default_dhcp_options_id
=======
route_rules {
  destination = "0.0.0.0/0"  #data.oci_core_services.test_services.services[0]["cidr_block"]
  destination_type = "CIDR_BLOCK"
  #network_entity_id = oci_core_service_gateway.example.id
   network_entity_id = oci_core_nat_gateway.nat_gateway.id
}
}
#Private subnet
resource "oci_core_subnet" "Bastion_subnet" {
  count               = 2
  availability_domain   = "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
  cidr_block            = count.index == 0 ? "10.0.0.0/18" : "10.0.64.0/18"
  display_name          = "Bastion_0${count.index + 1}"
  vcn_id              = oci_core_vcn.my_vcn.id
  compartment_id      = var.oci_compartment
  prohibit_public_ip_on_vnic = true
  security_list_ids   = [oci_core_security_list.terraformsecuritylist.id]
  route_table_id      = oci_core_vcn.my_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.my_vcn.default_dhcp_options_id
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
}


#public subnet for public lb
<<<<<<< HEAD
#resource "oci_core_subnet" "Public_subnet" {
#  count                      = 2
#  availability_domain        = "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
#  cidr_block                 = count.index == 0 ? "10.0.128.0/24" : "10.0.129.0/24"
#  display_name               = "pub_sub${count.index + 1}"
#  prohibit_public_ip_on_vnic = false
#  vcn_id                     = oci_core_vcn.my_vcn.id
#  compartment_id             = var.oci_compartment
#  security_list_ids          = [oci_core_security_list.terraformsecuritylist.id]
#  route_table_id             = oci_core_vcn.my_vcn.default_route_table_id
#  dhcp_options_id            = oci_core_vcn.my_vcn.default_dhcp_options_id
#}
=======
resource "oci_core_subnet" "Public_subnet" {
  count = 2
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-${count.index + 1}"
  cidr_block            = count.index == 0 ? "10.0.128.0/24" : "10.0.129.0/24"
  display_name    = "pub_sub${count.index + 1}"
  prohibit_public_ip_on_vnic = false
  vcn_id          = oci_core_vcn.my_vcn.id
  compartment_id = var.oci_compartment
  security_list_ids   = [oci_core_security_list.terraformsecuritylist.id]
  route_table_id      = oci_core_vcn.my_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.my_vcn.default_dhcp_options_id
}
>>>>>>> d851fa01c3dbc97efcf807418c3a7ec0228e0ae6
