resource "aws_key_pair" "cluster" {
  key_name = "${var.key_name_prefix}_${var.name}"
  public_key = "${var.ssh_public_key}"
  lifecycle { create_before_destroy = true }
}


# Create our main VPC in one region
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_support = "${var.vpc_enable_dns_support}"
  enable_dns_hostnames = "${var.vpc_enable_dns_hostnames}"
  enable_classiclink = "${var.vpc_enable_classiclink}"
  lifecycle { create_before_destroy = true }
  tags {
    Name = "${var.vpc_prefix}-${var.name}"
    project = "${var.name}"
  }
}

#  After creating a VPC, you can add one or more subnets in each Availability
#  Zone. Each subnet must reside entirely within one Availability Zone and
#  cannot span zones.
resource "aws_subnet" "subnet" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",", var.vpc_subnets), count.index)}"
  availability_zone = "${element(split(",", var.availability_zones), count.index)}"
  map_public_ip_on_launch = "${var.subnet_map_public_ip_on_launch}"
  count             = "${length(compact(split(",", var.vpc_subnets)))}"
  tags {
    Name = "${var.subnet_prefix}_${var.name}_${element(split(",", var.availability_zones), count.index)}"
    project = "${var.name}"
  }
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

    tags {
        Name = "${var.aws_route_table_prefix}_${var.name}"
        project = "${var.name}"
    }
}



# Create a DHCP Options set
resource "aws_vpc_dhcp_options" "vpc" {
  domain_name = "${var.region}.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags {
    Name = "${var.vpc_prefix}-${var.name}"
    project = "${var.name}"
  }
}

# Associate DHCP Options set and VPC together
resource "aws_vpc_dhcp_options_association" "vpc" {
  dhcp_options_id = "${aws_vpc_dhcp_options.vpc.id}"
  vpc_id = "${aws_vpc.vpc.id}"
}



resource "aws_internet_gateway" "main" {
	vpc_id = "${aws_vpc.vpc.id}"
    tags {
      Name    = "${var.aws_internet_gateway_prefix}_${var.name}"
      project = "${var.name}"
    }
}

resource "aws_route_table_association" "rta" {
    subnet_id       = "${element(aws_subnet.subnet.*.id, count.index)}"
    route_table_id  = "${aws_route_table.rt.id}"
    count           = "${length(compact(split(",", var.vpc_subnets)))}"
}

resource "aws_security_group" "sec_group" {
    name = "${var.aws_security_group_prefix}_${var.name}"
    description = "Main Security Group for ${var.name}"
    vpc_id = "${aws_vpc.vpc.id}"

    tags {
        Name = "${var.aws_security_group_prefix}_${var.name}"
        project = "${var.name}"
    }
}

resource "aws_security_group_rule" "allow_ssh" {
    type = "ingress"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.sec_group.id}"
}


# Allow all incoming communication within the cluster
resource "aws_security_group_rule" "allow_all_cluster" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    source_security_group_id = "${aws_security_group.sec_group.id}"
    security_group_id = "${aws_security_group.sec_group.id}"
}

# Allow all outoing communication within the cluster
resource "aws_security_group_rule" "allow_all_egress" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    source_security_group_id = "${aws_security_group.sec_group.id}"
    security_group_id = "${aws_security_group.sec_group.id}"
}
