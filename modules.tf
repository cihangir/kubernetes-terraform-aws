variable "aws_virt_type_list_source" {
  description = "Where to find the virtualization list."
  default     = "github.com/terraform-community-modules/tf_aws_virttype"
}

variable "aws_ami_list_source" {
  description = "Where to find the ami list."
  default     = "github.com/terraform-community-modules/tf_aws_coreos_ami"
}

variable "aws_ami_channel" {
  description = "Some distributions require a channel (stable, alpha etc)."
  default     = "stable"
}

variable "ami_id" {
  description = "Id of the ami."

  # default = "${module.ami_list.ami_id}"
  default = "ami-c40784a8"
}

module "ami_type_list" {
  # source        = "#{var.aws_virt_type_list_source}"
  source        = "github.com/terraform-community-modules/tf_aws_virttype"
  instance_type = "${var.instance_type}"
}

module "ami_list" {
  # source   = "${var.aws_ami_list_source}"
  source  = "github.com/terraform-community-modules/tf_aws_coreos_ami"
  channel = "${var.aws_ami_channel}"
  region  = "${var.region}"

  # virttype = "${module.ami_type_list.prefer_hvm}"
  virttype = "hvm"
}