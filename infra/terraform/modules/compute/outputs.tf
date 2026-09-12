#public output

output "public_ips" {

  value = {
    for node, instance in aws_instance.nodes :
    node => instance.public_ip
  }

}
#Private_ip

output "private_ips" {

  value = {
    for node, instance in aws_instance.nodes :
    node => instance.private_ip
  }

}