module "hosts" {
  source = "../../modules/hosts"
}

module "install_packages" {
  source   = "../../modules/install_packages"
  host_ip  = module.hosts.rancher_ip
  packages = "docker.io"
}

output "packages" {
  value = module.install_packages.output
}
