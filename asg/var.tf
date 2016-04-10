variable "name" {
  description = "Name of the application or project"
}

variable "aws_subnet_subnet_ids" {}

variable "region" {
  description = "AWS Region."
  default     = "sa-east-1"
}

variable "cloud_init_template_path" {
  description = "Path to the cloud init file template"
  default     = "../cloud_init.yml.tpl"
}

variable "desired_cluster_size" {
  description = "Desired number of servers to run in this cluster"
  default     = 2
}

variable "instance_type" {
  description = "AWS Instance type."
  default     = "t2.nano"
}

variable "ami_id" {
  description = "Id of the ami."

  # default = "${module.ami_list.ami_id}"
  default = "ami-c40784a8"
}

variable "key_name" {}

variable "associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC."
  default     = "true"
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring."
  default     = "true"
}

variable "max_cluster_size" {
  description = "Max number of servers to run in this cluster"
  default     = 3
}

variable "min_cluster_size" {
  description = "Min number of servers to run in this cluster"
  default     = 1
}

variable "availability_zones" {
  description = "AWS Region based AZs"
  default     = "sa-east-1a,sa-east-1b"
}

variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health."
  default     = 0
}

variable "health_check_type" {
  description = "EC2 or ELB. Controls how health checking is done."
  default     = "EC2"
}

# prefixes

variable "aws_iam_role_prefix" {
  default = "iam_role-"
}

variable "iam_instance_profile_prefix" {
  default = "iam_instance_profile-"
}

variable "aws_iam_role_policy_prefix" {
  default = "iam_role_policy-"
}

variable "aws_launch_configuration_prefix" {
  default = "launch_conf-"
}

variable "aws_autoscaling_group_prefix" {
  default = "asg-"
}
