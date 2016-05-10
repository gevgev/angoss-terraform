resource "aws_vpn_gateway" "vpn_gateway" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_customer_gateway" "customer_gateway" {
    bgp_asn = 60000
    ip_address = "${var.ipsec_peering_point}" /*"172.0.0.1"*/
    type = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
    vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
    type = "ipsec.1"
    static_routes_only = true
}

/* Adding route rules */
resource "aws_route" "rovi-1" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "${var.rovi_subnets.sub1}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    /*depends_on = ["aws_route_table.testing"]*/
}

resource "aws_route" "rovi-2" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "${var.rovi_subnets.sub2}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    /*depends_on = ["aws_route_table.testing"]*/
}

resource "aws_route" "rovi-3" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "${var.rovi_subnets.sub3}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    /*depends_on = ["aws_route_table.testing"]*/
}

/*
resource "aws_route_table" "rovi-1" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "${var.rovi_subnets.sub1}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
  }
}

/* Associate the routing table to public subnet *
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rovi-1.id}"
}
*

resource "aws_route_table" "rovi-2" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "${var.rovi_subnets.sub2}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
  }
}

/* Associate the routing table to public subnet *
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rovi-2.id}"
}
*

resource "aws_route_table" "rovi-3" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "${var.rovi_subnets.sub3}"
    gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
  }
}

/* Associate the routing table to public subnet *
resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id = "${aws_route_table.rovi-3.id}"
}
*/
