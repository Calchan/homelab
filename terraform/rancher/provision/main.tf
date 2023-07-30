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
      "export DEBIAN_FRONTEND=noninteractive",
      "apt-get -q update",
      "apt-get install -q -m -y -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' docker.io",
      "echo 'Pulling rancher image ...'",
      "docker pull -q rancher/rancher",
      "echo 'Starting rancher ...'",
      "docker run --privileged -d --restart=unless-stopped -p 80:80 -p 443:443 --name rancher rancher/rancher",
      "while ! docker logs rancher 2>&1 | grep 'Bootstrap Password:'; do sleep 1; done",
    ]
  }
}
