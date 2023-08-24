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
      source_security_group_id = module.sg_control_node.security_group_id
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
      source_security_group_id = module.sg_control_node.security_group_id
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
      source_security_group_id = module.sg_control_node.security_group_id
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

module "sg_control_node" {
  source = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "ansible-control-node"
  description = "Security group for ansible control nodes"
  vpc_id      = module.vpc.vpc_id

  egress_rules = [ "all-all" ]
  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = format("%s%s", var.my_ext_ip, "/32")
    },
  ]
}
