module "sg_database" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "database-node"
  description = "Security group for database node"
  vpc_id      = module.vpc.vpc_id

  egress_rules = [ "all-all" ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "postgresql-tcp"
      source_security_group_id = module.sg_backend.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      #source_security_group_id = module.sg_control_node.security_group_id
      source_security_group_id = aws_security_group.sg_control_node.id
    },
  ]
}

module "sg_backend" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "backend-node"
  description = "Security group for backend node"
  vpc_id      = module.vpc.vpc_id

  egress_rules = [ "all-all" ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = aws_security_group.sg_control_node.id
    },
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3333
      to_port     = 3333
      protocol    = "tcp"
      description = "Allow access to backend app"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "sg_frontend" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "frontend-node"
  description = "Security group for frontend nodes"
  vpc_id      = module.vpc.vpc_id

  egress_rules = [ "all-all" ]
  ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = aws_security_group.sg_control_node.id
    },
  ]
  ingress_with_cidr_blocks = [
    {
      from_port   = 3035
      to_port     = 3035
      protocol    = "tcp"
      description = "Allow access to frontend app"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

resource "aws_security_group" "sg_control_node" {
  name   = "ansible-control-node"
  vpc_id = module.vpc.vpc_id

  dynamic ingress {
    for_each = toset(var.allowed_cidr)
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ansible-control-node"
  }
}
