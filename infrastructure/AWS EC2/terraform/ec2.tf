module "ec2_database" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"


  name = "to-do-list-database"

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg_database.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]


  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}

module "ec2_backend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"


  name = "to-do-list-backend"

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg_backend.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}

module "ec2_frontend" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"


  name = "to-do-list-frontend"

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [module.sg_frontend.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}

module "ec2_control_node" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.2.1"


  name = "to-do-list-frontend"

  ami = data.aws_ami.private_ec2.id
  instance_type          = "t2.micro"
  key_name               = "west-2-key"
  monitoring             = true
  vpc_security_group_ids = [aws_security_group.sg_control_node.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data_replace_on_change = true
  user_data = <<EOF
#!/bin/bash
echo "alias ll='ls -lah --color=auto'" >> /etc/bashrc

apt update -y
apt install software-properties-common -y
add-apt-repository --yes --update ppa:ansible/ansible -y
apt install ansible -y
git clone https://github.com/phelipeavila/to-do-list.git /home/ubuntu/to-do-list
chown ubuntu:ubuntu /home /ubuntu /to-do-list -R 
  
EOF

  tags = {
    Terraform   = "true"
    Environment = "test"
    Subnet      = "default"
  }
}
