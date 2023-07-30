locals {

  rancher_ip    = "10.0.0.20"

  controller_ip = "10.0.0.21"

  worker_ips    = toset([
    "10.0.0.22",
    "10.0.0.23",
    "10.0.0.24",
  ])

}
