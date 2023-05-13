build {
  sources = [
    "source.amazon-ebs.aws_ubuntu"
  ]

  provisioner "file" {
    source      = "files/"
    destination = "/home/ubuntu/"
  }

  provisioner "shell" {
    script = "scripts/prometheus.sh"
  }


}