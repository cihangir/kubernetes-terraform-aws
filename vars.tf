variable "name" {
  description = "Name of the application or project"
}

variable "region" {
  description = "AWS Region."
  default     = "sa-east-1"
}

variable "availability_zones" {
  description = "AWS Region based AZs"
  default     = "sa-east-1a,sa-east-1b"
}

variable "instance_type" {
  description = "AWS Instance type."
  default     = "t2.nano"
}

variable "max_cluster_size" {
  description = "Max number of servers to run in this cluster"
  default     = 3
}

variable "min_cluster_size" {
  description = "Min number of servers to run in this cluster"
  default     = 1
}

variable "desired_cluster_size" {
  description = "Desired number of servers to run in this cluster"
  default     = 2
}

variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health."
  default     = 0
}

variable "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  default     = "EC2"
}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  default     = "true"
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring."
  default     = "true"
}

variable "cloud_init_template_path" {
  description = "Path to the cloud init file template"
  default     = "cloud_init.yml.tpl"
}

variable "ssh_public_key" {
  description = "Public key"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8u3tdgzNBq51ZNK0zXW1FziMU90drNgvY8uLi/zNOL1QuBwbRMNNGj/1ZyZmY+hV3VdmexA9AxsOofWEyvzUtL/hkJCmYglWGnTtIawOyDqTXi8Wjz4d00WW69zOiQqpAIAah5ejVsq9gpHslBy4amU+ExcxYoMYoz3ozccim++HkovLr9EhctfJuWvoPtrqljg4D9bn10eR0gdKNROxpnHPfX/Ge7NGcYAsvod5GsUI5zOV3lGfqJTKs+N1jxuqPVUKhoDiEimUQ4SoxBDneETdhRCZRVIQV7cwTfgw+kF58DqgTJCbwzyTyl9n7827Qi1Ha38oWhkAK+cB3uUgT cihangir@koding.com"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
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
  default = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
}

variable "subnet_map_public_ip_on_launch" {
  description = "Specify true to indicate that instances launched into the subnet should be assigned a public IP"
  default     = true
}

# prefixes

variable "iam_instance_profile_prefix" {
  default = "iam_instance_profile"
}

variable "aws_iam_role_policy_prefix" {
  default = "iam_role_policy"
}

variable "aws_iam_role_prefix" {
  default = "iam_role"
}

variable "aws_launch_configuration_prefix" {
  default = "launch_conf"
}

variable "aws_autoscaling_group_prefix" {
  default = "asg"
}

variable "vpc_prefix" {
  default = "vpc"
}

variable "vpc_dhcp_prefix" {
  default = "dhcp"
}

variable "subnet_prefix" {
  default = "subnet"
}

variable "aws_internet_gateway_prefix" {
  default = "igw"
}

variable "aws_route_table_prefix" {
  default = "rtb"
}

variable "aws_security_group_prefix" {
  default = "sg"
}

variable "key_name_prefix" {
  default = "key"
}

variable "aws_vpn_gateway_prefix" {
  default = "vgw"
}
