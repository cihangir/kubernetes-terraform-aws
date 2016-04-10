module "aws_sg" {
  source     = "../secgroups"
  name       = "${var.aws_elb_prefix}${var.name}"
  aws_vpc_id = "${var.aws_vpc_id}"
}

output "aws_elb_elb_aws_security_group_sec_group_id" {
  value = "${module.aws_sg.aws_security_group_sec_group_id}"
}

resource "aws_elb" "elb" {
  name = "${var.aws_elb_prefix}${var.name}"

  security_groups = ["${module.aws_sg.aws_security_group_sec_group_id}"]

  subnets = ["${split(",", var.aws_subnet_subnet_ids)}"]

  internal = "${var.is_internal}"

  listener {
    instance_port = "${var.aws_elb_instance_port}"

    instance_protocol = "${var.aws_elb_instance_protocol}"

    lb_port = "${var.aws_elb_port}"

    lb_protocol = "${var.aws_elb_protocol}"

    ssl_certificate_id = "${var.aws_elb_ssl_certificate_id}"
  }

  health_check {
    healthy_threshold = "${var.aws_elb_health_check_healthy_threshold}"

    unhealthy_threshold = "${var.aws_elb_health_check_unhealthy_threshold}"

    target = "${var.aws_elb_health_check_target}"

    interval = "${var.aws_elb_health_check_interval}"

    timeout = "${var.aws_elb_health_check_timeout}"
  }

  cross_zone_load_balancing = "${var.aws_elb_cross_zone_load_balancing}"

  idle_timeout = "${var.aws_elb_idle_timeout}"

  connection_draining = "${var.aws_elb_connection_draining}"

  connection_draining_timeout = "${var.aws_elb_connection_draining_timeout}"

  tags {
    Name    = "${var.aws_elb_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_elb_elb_id" {
  value = "${aws_elb.elb.id}"
}

output "aws_elb_elb_name" {
  value = "${aws_elb.elb.name}"
}

output "aws_elb_elb_dns_name" {
  value = "${aws_elb.elb.dns_name}"
}

output "aws_elb_elb_instances" {
  value = "${aws_elb.elb.instances}"
}

output "aws_elb_elb_source_security_group_id" {
  value = "${aws_elb.elb.source_security_group_id}"
}

output "aws_elb_elb_zone_id" {
  value = "${aws_elb.elb.elb_zone_id}"
}
