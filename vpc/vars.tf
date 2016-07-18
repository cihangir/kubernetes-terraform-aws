variable "name" {
  description = "Name of the application or project"
}

variable "region" {
  description = "AWS Region."
  default     = "sa-east-1"
}

variable "availability_zones" {
  description = "AWS Region based AZs"
  default     = "sa-east-1a,sa-east-1b,sa-east-1c"
}

variable "ssh_public_key" {
  description = "Public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8u3tdgzNBq51ZNK0zXW1FziMU90drNgvY8uLi/zNOL1QuBwbRMNNGj/1ZyZmY+hV3VdmexA9AxsOofWEyvzUtL/hkJCmYglWGnTtIawOyDqTXi8Wjz4d00WW69zOiQqpAIAah5ejVsq9gpHslBy4amU+ExcxYoMYoz3ozccim++HkovLr9EhctfJuWvoPtrqljg4D9bn10eR0gdKNROxpnHPfX/Ge7NGcYAsvod5GsUI5zOV3lGfqJTKs+N1jxuqPVUKhoDiEimUQ4SoxBDneETdhRCZRVIQV7cwTfgw+kF58DqgTJCbwzyTyl9n7827Qi1Ha38oWhkAK+cB3uUgT cihangir@koding.com"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "172.20.0.0/16"
}

variable "vpc_enable_dns_support" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support."
  default     = true
}

variable "vpc_enable_classiclink" {
  description = "Whether or not the VPC has Classiclink enabled."
  default     = true
}

variable "vpc_subnets" {
  default = "172.20.1.0/24,172.20.2.0/24,172.20.3.0/24"
}

variable "subnet_map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP"
  default     = true
}

# prefixes

variable "key_name_prefix" {
  default = "key-"
}

variable "vpc_prefix" {
  default = "vpc-"
}

variable "subnet_prefix" {
  default = "subnet-"
}

variable "aws_route_table_prefix" {
  default = "rtb-"
}

variable "vpc_dhcp_prefix" {
  default = "dhcp-"
}

variable "aws_internet_gateway_prefix" {
  default = "igw-"
}

variable "aws_vpn_gateway_prefix" {
  default = "vgw-"
}

variable "aws_network_acl_prefix" {
  default = "acl-"
}
