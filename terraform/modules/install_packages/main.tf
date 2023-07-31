terraform {
  required_providers {
    linux = {
      source = "TelkomIndonesia/linux"
    }
  }
}

provider "linux" {
  host    = var.host_ip
  user    = "root"
  agent   = true
  timeout = "30s"
}

locals {
  apt-get_pre = "export DEBIAN_FRONTEND=noninteractive &&"
  apt-get     = "apt-get -y -m -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'"
}

resource "linux_script" "install_packages" {
  lifecycle_commands {
    create = "${local.apt-get_pre} ${local.apt-get} install ${var.packages}"
    read   = "apt list --installed ${var.packages} 2>/dev/null | sed '/^Listing/d' | head -c -1"
    update = "${local.apt-get_pre} ${local.apt-get} install ${var.packages}"
    delete = "${local.apt-get_pre} ${local.apt-get} purge ${var.packages} && ${local.apt-get} autopurge"
  }
}

output "output" {
  value = linux_script.install_packages.output
}
