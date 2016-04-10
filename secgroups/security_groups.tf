resource "aws_security_group" "sec_group" {
  name        = "${var.aws_security_group_prefix}${var.name}"
  description = "Main Security Group for ${var.name}"
  vpc_id      = "${var.aws_vpc_id}"

  tags {
    Name    = "${var.aws_security_group_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_security_group_sec_group_id" {
  value = "${aws_security_group.sec_group.id}"
}

resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sec_group.id}"
}

output "aws_security_group_rule_allow_ssh_id" {
  value = "${aws_security_group_rule.allow_ssh.id}"
}

# Allow all incoming communication within the cluster
resource "aws_security_group_rule" "allow_all_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = "${aws_security_group.sec_group.id}"
  security_group_id        = "${aws_security_group.sec_group.id}"
}

output "aws_security_group_rule_allow_all_ingress_id" {
  value = "${aws_security_group_rule.allow_all_ingress.id}"
}

# Allow all outoing communication within the cluster
resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sec_group.id}"
}

output "aws_security_group_rule_allow_all_egress_id" {
  value = "${aws_security_group_rule.allow_all_egress.id}"
}