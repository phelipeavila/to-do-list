# module "vpc" {
#   source  = "terraform-aws-modules/vpc/aws"
#   version = "5.1.1"

#   name = "my-vpc"
#   cidr = "10.0.0.0/16"

#   azs             = ["us-west-2a", "us-west-2b"]
#   private_subnets = ["10.0.1.0/25", "10.0.2.0/25"]
#   public_subnets  = ["10.0.1.128/25", "10.0.2.128/25"]

#   enable_dns_hostnames = true
#   enable_dns_support   = true

#   # enable_nat_gateway = true

#   map_public_ip_on_launch = true

#   tags = {
#     Terraform   = "true"
#     Environment = "test"
#   }
# }

# module "nat_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.2.1"

#   for_each = toset(module.vpc.public_subnets)

#   name = "nat-instance"

#   ami = data.aws_ami.nat_instance.id
#   instance_type          = "t2.micro"
#   key_name               = "west-2-key"
#   monitoring             = true
#   vpc_security_group_ids = [module.vote_service_sg.security_group_id]
#   subnet_id              = each.key
#   source_dest_check      = false

#   tags = {
#     Terraform   = "true"
#     Environment = "test"
#     Subnet      = each.key
#   }
# }

# module "ansible_master" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.2.1"


#   name = "ansible-master"

#   ami = data.aws_ami.private_ec2.id
#   instance_type          = "t2.micro"
#   key_name               = "west-2-key"
#   monitoring             = true
#   vpc_security_group_ids = [module.sg_master.security_group_id]
#   subnet_id              = "subnet-0608bda612556e30c"
#   source_dest_check      = false
#   user_data_replace_on_change = true
#   user_data = <<EOF
# #!/bin/bash
# echo "alias ll='ls -lah --color=auto'" >> /etc/bashrc

# yum update -y
# dnf install python3.11 -y
# dnf install python3-pip -y
# pip install ansible
  
# EOF

#   tags = {
#     Terraform   = "true"
#     Environment = "test"
#     Subnet      = "default"
#   }
# }

# variable "nodes" {
#   type = list(string)
#   default = ["1", "2"]
# }

# module "ansible_nodes" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "5.2.1"

#   for_each = toset(var.nodes)

#   name = format("%s%s", "ansible-node-", each.key)

#   ami = data.aws_ami.private_ec2.id
#   instance_type          = "t2.micro"
#   key_name               = "west-2-key"
#   monitoring             = true
#   vpc_security_group_ids = [module.sg_nodes.security_group_id]
#   subnet_id              = "subnet-0608bda612556e30c"
#   source_dest_check      = false
#   user_data_replace_on_change = true
#   user_data = <<EOF
# #!/bin/bash
# echo "alias ll='ls -lah --color=auto'" >> /etc/bashrc

# yum update -y
# dnf install python3.11 -y
# dnf install python3-pip -y
# pip install ansible
  
# EOF

#   tags = {
#     Terraform   = "true"
#     Environment = "test"
#     Subnet      = "default"
#   }
# }

# output "master_ext_ip" {
#   value = module.ansible_master.public_ip
# }

# output "nodes_ext_ip" {
#   value = values(module.ansible_nodes).*.public_ip

# }

# module "sg_master" {
#   source = "terraform-aws-modules/security-group/aws"
#   version = "5.1.0"

#   name        = "ansible-master"
#   description = "Security group for ansible master node"
#   vpc_id      = "vpc-027bb666074a77701"

#   egress_rules = [ "all-all" ]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "Allow ssh user access "
#       cidr_blocks = "185.153.176.47/32"
#     },
#   ]
# }

# module "sg_nodes" {
#   source = "terraform-aws-modules/security-group/aws"
#   version = "5.1.0"

#   name        = "ansible-master"
#   description = "Security group for ansible master node"
#   vpc_id      = "vpc-027bb666074a77701"

#   egress_rules = [ "all-all" ]
#   ingress_with_cidr_blocks = [
#     {
#       from_port   = 22
#       to_port     = 22
#       protocol    = "tcp"
#       description = "Allow ssh user access "
#       cidr_blocks = "185.153.176.47/32"
#     },
#   ]
# }

# output "name" {
#   value = module.vpc.public_subnets
# }

# output "namee" {
#   value = module.vpc.public_subnets_cidr_blocks
# }

# data "aws_ami" "nat_instance" {
#   most_recent = true
#   name_regex = "^amzn-ami-vpc-nat*"
#   owners = ["amazon"]
# }

# data "aws_ami" "private_ec2" {
#   most_recent = true
#   name_regex = "^al2023-ami-2023*"
#   owners = ["amazon"]
  
#   filter {
#     name = "architecture"
#     values = [ "x86_64" ]
#   }
# }

# locals {
#   subnet_pairs = zipmap(module.vpc.public_subnets, module.vpc.private_subnets)
#   az_pairs = merge(
#     zipmap(module.vpc.private_subnets, module.vpc.azs),
#     zipmap(module.vpc.public_subnets, module.vpc.azs)
#   )
#   # set_pair = toset(local.subnet_pairs)
# }


# output "pairs" {
#   value = local.subnet_pairs
# }

# output "azs" {
#   value = local.az_pairs
# }