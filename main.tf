module "aws_vpc" {
  source = "./vpc"
  name   = "${var.name}"
}

module "aws_sg" {
  source     = "./secgroups"
  name       = "${var.name}"
  aws_vpc_id = "${module.aws_vpc.aws_vpc_vpc_id}"
}

module "aws_asg" {
  source                = "./asg"
  name                  = "${var.name}"
  aws_subnet_subnet_ids = "${module.aws_vpc.aws_subnet_subnet_ids}"
  key_name              = "${module.aws_vpc.aws_key_name}"
  load_balancer_names   = "${module.aws_elb.aws_elb_elb_name}"
}

module "aws_elb" {
  source                = "./elb"
  name                  = "${var.name}"
  aws_vpc_id            = "${module.aws_vpc.aws_vpc_vpc_id}"
  aws_subnet_subnet_ids = "${module.aws_vpc.aws_subnet_subnet_ids}"
}
