variable "name" {
  description = "Name of the application or project"
}

variable "aws_vpc_id" {
  description = "AWS VPC Id."
}

# prefixes

variable "aws_security_group_prefix" {
  default = "sec-group-"
}