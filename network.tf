provider "oci" {
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
}
output "services" {
  value = [data.oci_core_services.test_services.services]
}

resource "oci_core_vcn" "my_vcn" {
  cidr_block = "10.0.0.0/16"
  display_name = "my_vcn"
  dns_label = "examplevcn"
  compartment_id = var.oci_compartment
}

resource "oci_core_security_list" "terraformsecuritylist" {
  display_name   = "terraformsecuritylist"
  compartment_id = oci_core_vcn.my_vcn.compartment_id
  vcn_id         = oci_core_vcn.my_vcn.id

egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

ingress_security_rules {
    description     = "Allow SSH traffic"
    protocol        = "all"    
    source          = "0.0.0.0/0"
    }
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
  #Required
#  compartment_id = var.oci_compartment

  #Optional
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
route_rules {
  destination = "0.0.0.0/0"  #data.oci_core_services.test_services.services[0]["cidr_block"]
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
}

#public subnet for public lb
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
