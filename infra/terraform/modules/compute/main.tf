locals {
  nodes = {
    control = "k3s-control"
    worker1 = "k3s-worker-1"
    worker2 = "k3s-worker-2"
  }
}

#Create the Ec2 instance

resource "aws_instance" "nodes" {

  for_each = local.nodes

  ami                    = var.ami

  instance_type          = var.instance_type

  key_name               = var.key_name

  subnet_id              = var.subnet_id

  vpc_security_group_ids = [var.security_group_id]

  associate_public_ip_address = true

  tags = {
    Name = each.value
    Role = each.key
  }

}