terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

module "hosts" {
  source = "../../modules/hosts"
}

resource "null_resource" "update" {
  for_each = module.hosts.all_ips
  triggers = {
    always_run = "${timestamp()}"
  }
  connection {
    host = each.value
  }
  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get -q update",
      "apt-get dist-upgrade -q -m -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold'",
      "apt-get -q -y autopurge",
      "shutdown -r now",
    ]
  }
}
