/* ----------- Angoss ----------- */
/* Private subnet */
resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags { 
    Name = "private" 
  }
}

/* Routing table for private subnets (both) */
resource "aws_route_table" "private" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${aws_instance.nat.id}"
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "private" {
  subnet_id = "${aws_subnet.private.id}"
  route_table_id = "${aws_route_table.private.id}"
}

/* -------- DaaS ---------------- */
/* Private subnet */
resource "aws_subnet" "private-daas" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet_cidr_daas}"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = false
  depends_on = ["aws_instance.nat"]
  tags { 
    Name = "private-daas" 
  }
}

/* Associate the routing table to public subnet */
resource "aws_route_table_association" "private-daas" {
  subnet_id = "${aws_subnet.private-daas.id}"
  route_table_id = "${aws_route_table.private.id}"
}