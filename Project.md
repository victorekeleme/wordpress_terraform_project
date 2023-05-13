/*
Flow of execution
1. Configure provider (aws, region)
2. Create VPC resource (cidr_block, tags)
3. Create subnet resource (vpc_id, cidr_block, availability_zone, tags)
4. Create internet_gateway resource (vpc_id, tags)
5. Create route_table resource (default_route_table_id(= default) or vpc_id(!= Default), route(cidr_block=[0.0.0.0/0], gateway_id), tags)
   >> If not using default_route_table:
      we have to create aws_route_table_association (subnet_id, route_table_id)
6. Create security_group resource (vpc_id, ingress(from_port, to_port, protocol, cidr_blocks), egress(same as ingress), tags)
7. Create key_pair resource (key_name, public_key)
8. Create instance resource (ami, subnet_id, vpc_security_group_ids/security_groups, availability_zone, associate_public_ip_address, key_name, user_data(for bootstraping the instance), tags )
   >> For Provisioner Implementation:
      connection (type, host, user, private_key)
      Create provisioner "file" (source, destination)
      Create provisioner "remote-exec" (script)
      Create provisioner "local-exec" (command)
*/