resource "aws_key_pair" "cluster" {
  key_name   = "${var.key_name_prefix}${var.name}"
  public_key = "${var.ssh_public_key}"

  lifecycle {
    create_before_destroy = true
  }
}

output "aws_key_name" {
  value = "${aws_key_pair.cluster.key_name}"
}

# Create our main VPC in one region
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = "${var.vpc_enable_dns_support}"
  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
  enable_classiclink   = "${var.vpc_enable_classiclink}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name    = "${var.vpc_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_vpc_vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

#  After creating a VPC, you can add one or more subnets in each Availability
#  Zone. Each subnet must reside entirely within one Availability Zone and
#  cannot span zones.
resource "aws_subnet" "subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${element(split(",", var.vpc_subnets), count.index)}"
  availability_zone       = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = "${var.subnet_map_public_ip_on_launch}"
  count                   = "${length(compact(split(",", var.vpc_subnets)))}"

  tags {
    Name    = "${var.subnet_prefix}${var.name}_${element(split(",", var.availability_zones), count.index)}"
    project = "${var.name}"
  }
}

output "aws_subnet_subnet_ids" {
  value = "${join(",", aws_subnet.subnet.*.id)}"
}

# Provides an network ACL resource. You might set up network ACLs with rules
# similar to your security groups in order to add an additional layer of
# security to your VPC.
resource "aws_network_acl" "acl" {
  vpc_id = "${aws_vpc.vpc.id}"
  subnet_ids = "${aws_subnet.subnet.*.id}"

  tags {
    Name    = "${var.aws_network_acl_prefix}${var.name}"
    project = "${var.name}"
  }
}


output "aws_network_acl_acl_id" {
  # The ID of the network ACL
  value = "aws_network_acl.acl.id"
}

resource "aws_network_acl_rule" "allow_all_ingress" {
    network_acl_id = "${aws_network_acl.acl.id}"
    rule_number = 100
    egress      = false
    protocol    = "-1"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
}

output "aws_network_acl_rule_allow_all_ingress_id" {
  value = "aws_network_acl_rule.allow_all_ingress.id"
}

resource "aws_network_acl_rule" "allow_all_egress" {
    network_acl_id = "${aws_network_acl.acl.id}"
    rule_number = 100
    egress      = true
    protocol    = "-1"
    rule_action = "allow"
    cidr_block  = "0.0.0.0/0"
    from_port   = 0
    to_port     = 0
}

output "aws_network_acl_rule_allow_all_egress_id" {
  value = "aws_network_acl_rule.allow_all_egress.id"
}


# By design, each subnet must be associated with a route table, which specifies
# the allowed routes for outbound traffic leaving the subnet. Every subnet that
# you create is automatically associated with the main route table for the VPC.
# You can change the association, and you can change the contents of the main
# route table.
resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  propagating_vgws = ["${aws_vpn_gateway.vpn_gw.id}"]

  tags {
    Name    = "${var.aws_route_table_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_route_table_rt_id" {
  value = "${aws_route_table.rt.id}"
}

# Create a DHCP Options set
resource "aws_vpc_dhcp_options" "vpc" {
  domain_name         = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags {
    Name    = "${var.vpc_dhcp_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_vpc_dhcp_options_vpc_id" {
  value = "${aws_vpc_dhcp_options.vpc.id}"
}

# Associate DHCP Options set and VPC together
resource "aws_vpc_dhcp_options_association" "vpc" {
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc.id}"
  vpc_id          = "${aws_vpc.vpc.id}"
}

output "aws_vpc_dhcp_options_association_vpc_id" {
  value = "${aws_vpc_dhcp_options_association.vpc.id}"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.aws_internet_gateway_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_internet_gateway_main_id" {
  value = "${aws_internet_gateway.main.id}"
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name    = "${var.aws_vpn_gateway_prefix}${var.name}"
    project = "${var.name}"
  }
}

output "aws_vpn_gateway_vpn_gw_id" {
  value = "${aws_vpn_gateway.vpn_gw.id}"
}

resource "aws_route_table_association" "rta" {
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.rt.id}"
  count          = "${length(compact(split(",", var.vpc_subnets)))}"
}

output "aws_route_table_association_rta_id" {
  value = "${aws_route_table_association.rta.id}"
}
