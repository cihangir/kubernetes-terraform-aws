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

module "aws_asg_kube_masters" {
  source = "../secgrouprules"
  sec_group_id = "${aws_security_group.sec_group.id}"
}
