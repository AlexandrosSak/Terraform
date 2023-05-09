# Create a private load balancer
resource "oci_load_balancer_load_balancer" "private_lb" {
  compartment_id            = var.oci_compartment
  display_name              = "private_lb"
  shape                     = "flexible"
  shape_details {
  minimum_bandwidth_in_mbps = 10
  maximum_bandwidth_in_mbps = 100
}
  subnet_ids                = [oci_core_subnet.Bastion_subnet[0].id]
  is_private                = true

}
# Private Load Balancer Listener
resource "oci_load_balancer_listener" "private_lb_listener" {
  name              = "private_lb_listener"
  default_backend_set_name =  oci_load_balancer_backend_set.private_lb_backend.name
  protocol          = "TCP"
  port              = 80  
  load_balancer_id  = oci_load_balancer_load_balancer.private_lb.id
}
# Backend resources for private instances
resource "oci_load_balancer_backend" "private_lb_backend_instance" {
  count              = 2  
  ip_address         = oci_core_instance.TEST-Comp-Inst[count.index].private_ip
  load_balancer_id   = oci_load_balancer_load_balancer.private_lb.id
  port               = 80 
  backendset_name    = oci_load_balancer_backend_set.private_lb_backend.name 
}
# Backend set for private load balancer
resource "oci_load_balancer_backend_set" "private_lb_backend" {
  load_balancer_id  = oci_load_balancer_load_balancer.private_lb.id
  name              = "private_lb_backend"
  policy            = "ROUND_ROBIN"
  health_checker {
           protocol = "HTTP"
           url_path = "/"
               port = 80
}
}
#data "oci_core_private_ip" "LB_private_ip" {
#  private_ip_id = oci_load_balancer_load_balancer.private_lb.ip_address
#}
#Create a public load balancer
#resource "oci_load_balancer_load_balancer" "public_lb" {
#  compartment_id = var.oci_compartment
#  display_name   = "public_nlb"
#  subnet_ids = [oci_core_subnet.Public_subnet[0].id]
#  shape = "flexible"
#  is_private     = false
#}

# Public Load Balancer Backends
#resource "oci_load_balancer_backend" "public_lb_backend" {
#  ip_address = oci_load_balancer_load_balancer.private_lb.private_ips
#  port              = 80
#  load_balancer_id  = oci_load_balancer_load_balancer.public_lb.id
#  backendset_name   = oci_load_balancer_backend_set.public_lb_backend_set.name #"public_lb_backend"
#}

# Public Load Balancer Listener
#resource "oci_load_balancer_listener" "public_lb_listener" {
#  name              = "public_listener"
#  default_backend_set_name = "public_backend_set" #oci_load_balancer_backend_set.public_lb_backend_set.name
#  protocol          = "HTTP"
#  port              = 80
#  load_balancer_id  = oci_load_balancer_load_balancer.public_lb.id
#}


#Public backend set
#resource "oci_load_balancer_backend_set" "public_lb_backend_set" {
#  load_balancer_id = oci_load_balancer_load_balancer.public_lb.id
#  name = "public_lb_backend"
#  policy = "ROUND_ROBIN"
#  health_checker {
#  protocol = "HTTP"
#  url_path = "/"
#  port = 80
#  return_code = 200
#  retries = 3
#  timeout_in_millis = 3000
#}
#}
