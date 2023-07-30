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
  triggers = {
    always_run = "${timestamp()}"
  }
  connection {
    host = "${module.hosts.rancher_ip}"
  }
  provisioner "remote-exec" {
    inline = [
      "yes | docker system prune --all",
      "apt-get -q -y purge docker.io",
      "apt-get -q -y autopurge",
      "shutdown -r now"
    ]
  }
}
