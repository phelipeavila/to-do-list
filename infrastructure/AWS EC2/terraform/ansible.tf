module "ansible_control_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"


  name = "ansible-control-node"

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg_control_node.security_group_id]
  subnet_id              = "subnet-0608bda612556e30c"
  source_dest_check      = false
  user_data_replace_on_change = true
  user_data = <<EOF
#!/bin/bash
echo "alias ll='ls -lah --color=auto'" >> /etc/bashrc

dnf update -y
dnf install python3.11 -y
dnf install python3-pip -y
pip install ansible
  
EOF

  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}

variable "nodes" {
  type = list(string)
  default = ["1", "2", "3"]
}

module "ansible_managed_nodes" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"

  for_each = toset(var.nodes)

  name = format("%s%s", "ansible-node-", each.key)

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg_managed_nodes.security_group_id]
  subnet_id              = "subnet-0608bda612556e30c"
  source_dest_check      = false
  user_data_replace_on_change = true
  user_data = <<EOF
#!/bin/bash
echo "alias ll='ls -lah --color=auto'" >> /etc/bashrc

dnf update -y
dnf install python3.11 -y
dnf install python3-pip -y
pip install ansible
  
EOF

  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}

output "master_ext_ip" {
  value = module.ansible_control_node.public_ip
}

output "nodes_ext_ip" {
  value = values(module.ansible_managed_nodes).*.public_ip

}

module "sg_control_node" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "ansible-master"
  description = "Security group for ansible master node"
  vpc_id      = "vpc-027bb666074a77701"

  egress_rules = [ "all-all" ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow ssh user access "
      cidr_blocks = "200.140.155.82/32"
    },
  ]
}

module "sg_managed_nodes" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "ansible-master"
  description = "Security group for ansible managed nodes"
  vpc_id      = "vpc-027bb666074a77701"

  egress_rules = [ "all-all" ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.sg_control_node.security_group_id
    }
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "Allow ssh user access "
      cidr_blocks = "200.140.155.82/32"
    },
  ]
}

data "aws_ami" "private_ec2" {
  most_recent = true
  # name_regex = "^al2023-ami-2023*"
  name_regex = "^ubuntu/images/hvm-ssd/ubuntu-jammy-22.04*"
  owners = ["amazon"]
  
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}