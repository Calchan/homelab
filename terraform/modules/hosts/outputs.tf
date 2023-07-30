output "rancher_ip" {
  value = local.rancher_ip
}

output "controller_ip" {
  value = local.controller_ip
}

output "worker_ips" {
  value = local.worker_ips
}

output "all_ips" {
  value = setunion([local.rancher_ip], [local.controller_ip], local.worker_ips)
}
