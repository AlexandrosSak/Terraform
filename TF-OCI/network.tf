provider "oci" {
  tenancy_ocid = var.oci_tenancy
  user_ocid = var.oci_user
  fingerprint = var.oci_fingerprint
  private_key_path = var.oci_key
  region = var.oci_region
}

resource "oci_core_vcn" "my_vcn" {
  cidr_block = "10.0.0.0/16"
  display_name = "my_vcn"
  dns_label = "examplevcn"
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaqrgldxcnc466mrneqbilp2fd4oxjsehq7ht7jeiqclws55aodwna"
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
    protocol        = "6"    # TCP
    source          = "0.0.0.0/0"
    tcp_options {
        min = 22
        max = 22
      }
    }

ingress_security_rules {
    description     = "Allow LB Listener"
    protocol        = "6"    # TCP
    source          = "0.0.0.0/0"
    tcp_options {
        min = 80
        max = 80
      }
    }
  

  ingress_security_rules {
    description     = "Allow ping traffic"
    protocol        = "1"    # ICMP
    source          = "0.0.0.0/0"
}

ingress_security_rules {
    description = "Allow NFS traffic"
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    tcp_options {
        min = 2048
        max = 2050
    }
  }
ingress_security_rules {
    description = "Allow NFS traffic"
    protocol    = "6" # TCP
    source      = "0.0.0.0/0"
    tcp_options {
        min = 111
        max = 111
    }
  }
ingress_security_rules {
    description = "Allow NFS traffic"
    protocol    = "17" # UDP
    source      = "0.0.0.0/0"
    udp_options {
        min = 111
        max = 111
    }
  }
ingress_security_rules {
    description = "Allow NFS traffic"
    protocol    = "17" # UDP
    source      = "0.0.0.0/0"
    udp_options {
        min = 2048
        max = 2048
    }
  }

}

resource "oci_core_internet_gateway" "terraforminternetgateway1" {
  compartment_id = "ocid1.compartment.oc1..aaaaaaaaqrgldxcnc466mrneqbilp2fd4oxjsehq7ht7jeiqclws55aodwna"
  display_name   = "terraforminternetgateway1"
  vcn_id         = oci_core_vcn.my_vcn.id
}

resource "oci_core_default_route_table" "default_route_table" {
  manage_default_resource_id = oci_core_vcn.my_vcn.default_route_table_id
  display_name               = "DefaultRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.terraforminternetgateway1.id
  }
}

resource "oci_core_subnet" "my_subnet_01" {
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-1"
  cidr_block      = "10.0.0.0/17"
  display_name    = "my_subnet_01"
  vcn_id          = oci_core_vcn.my_vcn.id
  compartment_id  = "ocid1.compartment.oc1..aaaaaaaaqrgldxcnc466mrneqbilp2fd4oxjsehq7ht7jeiqclws55aodwna"
  security_list_ids   = [oci_core_security_list.terraformsecuritylist.id]
  route_table_id      = oci_core_vcn.my_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.my_vcn.default_dhcp_options_id
}

resource "oci_core_subnet" "my_subnet_02" {
  availability_domain = "sgAm:EU-FRANKFURT-1-AD-2"
  cidr_block      = "10.0.128.0/17"
  display_name    = "my_subnet_02"
  vcn_id          = oci_core_vcn.my_vcn.id
  compartment_id  = "ocid1.compartment.oc1..aaaaaaaaqrgldxcnc466mrneqbilp2fd4oxjsehq7ht7jeiqclws55aodwna"
  security_list_ids   = [oci_core_security_list.terraformsecuritylist.id]
  route_table_id      = oci_core_vcn.my_vcn.default_route_table_id
  dhcp_options_id     = oci_core_vcn.my_vcn.default_dhcp_options_id
}
