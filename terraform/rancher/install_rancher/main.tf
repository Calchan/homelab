terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host     = "ssh://root@${module.hosts.rancher_ip}"
  ssh_opts = ["-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}

module "hosts" {
  source = "../../modules/hosts"
}

resource "random_string" "bootstrap_password" {
  length  = 32
  special = false
}

resource "docker_container" "rancher" {
  name       = "rancher"
  image      = "rancher/rancher"
  privileged = true
  attach     = false
  restart    = "unless-stopped"
  ports {
    internal = 80
    external = 80
  }
  ports {
    internal = 443
    external = 443
  }
  env = ["CATTLE_BOOTSTRAP_PASSWORD=${random_string.bootstrap_password.result}"]
}

output "bootstrap_password" {
  value = random_string.bootstrap_password.result
}
