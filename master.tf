# Template file for cloud init info
resource "template_file" "cloud_init" {
  template   = "${var.cloud_init_template_path}"
  vars {
    name                   = "${var.name}"
    region                 = "${var.region}"
    desired_cluster_size   = "${var.desired_cluster_size}"
  }
}

# This specific role gives access to all resources in AWS
# TODO(cihangir)  give fine/granular access to roles
resource "aws_iam_role" "aws_all_role" {
    name = "${var.aws_iam_role_prefix}_${var.name}_aws_all"
    path = "/"
    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {"AWS": "*"},
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

# We need to create an instance profile to assign to instances
resource "aws_iam_instance_profile" "cluster_instance_profile" {
    name = "${var.iam_instance_profile_prefix}_${var.name}"
    roles = ["${aws_iam_role.aws_all_role.name}"]
}

resource "aws_iam_role_policy" "master" {
    name = "${var.aws_iam_role_policy_prefix}_${var.name}"
    role = "${aws_iam_role.aws_all_role.name}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "elasticloadbalancing:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

# Launch configuration to create a cluster with
resource "aws_launch_configuration" "cluster" {
    name = "${var.aws_launch_configuration_prefix}_${var.name}"
    image_id = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${aws_iam_instance_profile.cluster_instance_profile.name}"
    key_name = "${var.key_name_prefix}_${var.name}"
    / * security_groups  = "${var.security_groups}" */
    associate_public_ip_address = "${var.associate_public_ip_address}"
    user_data = "${template_file.cloud_init.rendered}"
    enable_monitoring  = "${var.enable_monitoring}"
    /*
    lifecycle {
      create_before_destroy = true
    }
    */
}

resource "aws_autoscaling_group" "cluster" {
  name = "${var.aws_autoscaling_group_prefix}_${var.name}"
  max_size = "${var.max_cluster_size}"
  min_size = "${var.min_cluster_size}"
  availability_zones = ["${split(",", var.availability_zones)}"]
  launch_configuration = "${aws_launch_configuration.cluster.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  health_check_type = "${var.health_check_type}"
  desired_capacity = "${var.desired_cluster_size}"
  vpc_zone_identifier = ["${aws_subnet.subnet.*.id}"]
  metrics_granularity = "1Minute" /* only 1Minute is valid */

  tag {
    key = "Name"
    value = "${var.name}"
    propagate_at_launch = true
  }
}
