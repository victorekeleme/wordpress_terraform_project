data "template_file" "client" {
  template = file("user_data/run_on_client.sh")
}
data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  #first part of local config file
  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    
    sudo apt install wget -y

    echo WORDPRESS_DB_NAME=${aws_db_instance.wordpress_db.db_name} >> /home/ubuntu/wordpress.env
    echo WORDPRESS_DB_USER=${aws_db_instance.wordpress_db.username} >> /home/ubuntu/wordpress.env
    echo WORDPRESS_DB_PASSWORD=${aws_db_instance.wordpress_db.password} >> /home/ubuntu/wordpress.env
    echo WORDPRESS_DB_HOST=${aws_db_instance.wordpress_db.endpoint} >> /home/ubuntu/wordpress.env
    echo EFS_DNS_NAME=${aws_efs_file_system.wordpress_efs.dns_name} >> /home/ubuntu/efs
    
    EFS_DNS_NAME=$(cat /home/ubuntu/efs)
    sleep 5
    #Mounting EFS
    sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport $EFS_DNS_NAME:/ /var/www/html
    sleep 15
    sudo docker compose -f /home/ubuntu/docker_compose.yaml up -d

    #clean up
    sudo rm -rf /home/ubuntu/wordpress.env efs

    EOF
  }
  #second part
  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}