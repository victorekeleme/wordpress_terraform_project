build {
  sources = [
    "source.amazon-ebs.aws_ubuntu"
  ]

  provisioner "file" {
    source      = "scripts/docker_compose.yaml"
    destination = "/home/ubuntu/"
  }

  provisioner "file" {
    source      = "scripts/node_exporter.service"
    destination = "/home/ubuntu/"
  }
  
  provisioner "shell" {
    script = "scripts/start_up.sh"
  }

}