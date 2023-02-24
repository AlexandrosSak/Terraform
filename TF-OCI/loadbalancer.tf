resource "oci_load_balancer" "my_lb" {
compartment_id = var.oci_compartment
subnet_ids = [oci_core_subnet.my_subnet_01.id , oci_core_subnet.my_subnet_02.id ]
shape = "flexible"
shape_details {
  minimum_bandwidth_in_mbps = 10
  maximum_bandwidth_in_mbps = 100
}
display_name = "my_lb"
is_private = false
}

resource "oci_load_balancer_backend_set" "my_lb_backend_set" {
load_balancer_id = oci_load_balancer.my_lb.id
name = "my_lb_backend_set"
policy = "ROUND_ROBIN"
health_checker {
protocol = "HTTP"
url_path = "/"
port = 80
return_code = 200
retries = 3
timeout_in_millis = 3000
}
}

resource "oci_load_balancer_backend" "my_lb_backend_01" {
backendset_name = "my_lb_backend_set"
load_balancer_id = oci_load_balancer.my_lb.id
ip_address = oci_core_instance.TEST-Comp-Inst_01.private_ip
port = 80
weight = 1
}

resource "oci_load_balancer_backend" "my_lb_backend_02" {
backendset_name = "my_lb_backend_set"
load_balancer_id = oci_load_balancer.my_lb.id
ip_address = oci_core_instance.TEST-Comp-Inst_2.private_ip
port = 80
weight = 1
}

resource "oci_load_balancer_listener" "my_lb_listener" {
load_balancer_id = oci_load_balancer.my_lb.id
default_backend_set_name = oci_load_balancer_backend_set.my_lb_backend_set.name
name = "my_lb_listener"
port = 80
protocol = "HTTP"
}
