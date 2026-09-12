
module "network" {
  
  source = "./modules/network"

  vpc_cidr = var.vpc_cidr
  
  
  public_subnet_cidr = var.public_subnet
  
  
  availability_zone = var.availability_zone

  
}
module "security" {
    source = "./modules/security"
    
    vpc_id = module.network.vpc_id
    
    my_ip = var.my_ip
}


module "compute" {

  source = "./modules/compute"

  ami = data.aws_ami.ubuntu.id

  instance_type = var.instance_type

  key_name = var.key_name

  subnet_id = module.network.subnet_id

  security_group_id = module.security.security_group_id


}