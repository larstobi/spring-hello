output "load_balancer_hostname" {
  value = "${module.alb.dns_name}"
}
