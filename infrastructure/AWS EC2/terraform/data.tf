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