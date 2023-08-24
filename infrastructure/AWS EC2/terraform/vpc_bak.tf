# #################################################################
# # Variables
# #################################################################

# variable "vpc_configuration" {
#   type = object({
#     cidr_block = string
#     subnets = list(object({
#       name       = string
#       cidr_block = string
#       public     = bool
#     }))
#   })
#   default = {
#     cidr_block = "10.0.0.0/16"
#     subnets = [
#       {
#         name       = "private-a"
#         cidr_block = "10.0.1.0/25"
#         public     = false
#       },
#       {
#         name       = "private-b"
#         cidr_block = "10.0.2.0/25"
#         public     = false
#       },
#       {
#         name       = "public-a"
#         cidr_block = "10.0.1.128/25"
#         public     = true
#       },
#       {
#         name       = "public-b"
#         cidr_block = "10.0.2.128/25"
#         public     = true
#       }
#     ]
#   }
# }

# #################################################################
# # Locals
# #################################################################

# locals {
#   private_subnets = sort(
#   [for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == false])

#   public_subnets = sort(
#   [for subnet in var.vpc_configuration.subnets : subnet.name if subnet.public == true])

#   azs = sort(
#   slice(data.aws_availability_zones.available.zone_ids, 0, length(local.private_subnets)))

#   subnet_pairs = zipmap(local.private_subnets, local.public_subnets)

#   az_pairs = merge(
#     zipmap(local.private_subnets, local.azs),
#     zipmap(local.public_subnets, local.azs)
#   )
# }

# #################################################################
# # VPC
# #################################################################

# resource "aws_vpc" "this" {
#   cidr_block           = var.vpc_configuration.cidr_block
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags = {
#     "Name" = "my-vpc"
#     Provisioner = "terraform"
#     Environment = "test"
#   }
# }

# resource "aws_internet_gateway" "this" {
#   vpc_id = aws_vpc.this.id
# }

# resource "aws_subnet" "this" {
#   for_each                = { for subnet in var.vpc_configuration.subnets : subnet.name => subnet }
#   availability_zone_id    = local.az_pairs[each.key]
#   vpc_id                  = aws_vpc.this.id
#   cidr_block              = each.value.cidr_block
#   map_public_ip_on_launch = each.value.public

#   tags = {
#     Name        = each.key
#   }
# }

# resource "aws_nat_gateway" "this" {
#   for_each = toset(local.private_subnets)

#   allocation_id = aws_eip.nat_gateway[each.value].id
#   subnet_id     = aws_subnet.this[local.subnet_pairs[each.value]].id
# }

# resource "aws_eip" "nat_gateway" {
#   for_each = toset(local.private_subnets)
#   vpc      = true

#   depends_on = [
#     aws_internet_gateway.this
#   ]
# }

# #################################################################
# # Routes and Route tables
# #################################################################

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.this.id
# }

# resource "aws_route" "aws_internet_gateway" {
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = aws_route_table.public.id
#   gateway_id             = aws_internet_gateway.this.id
# }

# resource "aws_route_table_association" "public" {
#   for_each       = toset(local.public_subnets)
#   subnet_id      = aws_subnet.this[each.value].id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table" "private" {
#   for_each = toset(local.private_subnets)
#   vpc_id   = aws_vpc.this.id
# }

# resource "aws_route" "nat_gateway" {
#   for_each               = toset(local.private_subnets)
#   destination_cidr_block = "0.0.0.0/0"
#   route_table_id         = aws_route_table.private[each.value].id
#   nat_gateway_id         = aws_nat_gateway.this[each.value].id
# }

# resource "aws_route_table_association" "private" {
#   for_each       = toset(local.private_subnets)
#   subnet_id      = aws_subnet.this[each.value].id
#   route_table_id = aws_route_table.private[each.value].id
# }