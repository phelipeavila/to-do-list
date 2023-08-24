output "database_ext_ip" {
  value = module.ec2_database.public_ip
}

output "database_priv_ip" {
  value = module.ec2_database.private_ip
}

output "backend_ext_ip" {
  value = module.ec2_backend.public_ip
}

output "backend_priv_ip" {
  value = module.ec2_backend.private_ip
}

output "frontend_ext_ip" {
  value = module.ec2_frontend.public_ip
}

output "frontend_priv_ip" {
  value = module.ec2_frontend.private_ip
}

output "control_node_ext_ip" {
  value = module.ec2_control_node.public_ip
}

output "control_node_priv_ip" {
  value = module.ec2_control_node.private_ip
}
