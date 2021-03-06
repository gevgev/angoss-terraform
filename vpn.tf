resource "aws_vpn_gateway" "vpn_gateway" {
    vpc_id = "${aws_vpc.default.id}"
	lifecycle {  prevent_destroy = true  }
}

resource "aws_customer_gateway" "customer_gateway" {
    bgp_asn    	= "${var.customer_gw_asn}"
    ip_address 	= "${var.ipsec_peering_point}"
    type       	= "ipsec.1"
    tags { Name = "${var.customer_gw_name}"}
	lifecycle {  prevent_destroy = true  }
}

resource "aws_vpn_connection" "main" {
    vpn_gateway_id = "${aws_vpn_gateway.vpn_gateway.id}"
    customer_gateway_id = "${aws_customer_gateway.customer_gateway.id}"
    type = "ipsec.1"
    static_routes_only = true
    tags {  Name = "${var.vpc_name}-${var.customer_gw_name}"  }
	lifecycle {  prevent_destroy = true  }
}


/* Copied From rovi-fan-vpn - use of count */
resource "aws_vpn_connection_route" "route" {
  count                  = "${length(compact(split(",", var.destination_cidrs)))}"
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
  destination_cidr_block = "${element(compact(split(",", var.destination_cidrs)), count.index)}"
  /*lifecycle {  prevent_destroy = true  }*/
}


/* Adding route rules to public routing table of subnet */
resource "aws_route" "rovi-routes-public" {
	count                  = "${length(compact(split(",", var.destination_cidrs)))}"
    route_table_id         = "${aws_route_table.public.id}" 
    destination_cidr_block = "${element(compact(split(",", var.destination_cidrs)), count.index)}"
    gateway_id             = "${aws_vpn_gateway.vpn_gateway.id}"
    depends_on             = ["aws_route_table.public"]
    /*lifecycle {  ignore_changes = [true] }*/
}

/* Adding route rules to private routing table of subnet */
/* both private and private-daas are associated with this route */
resource "aws_route" "rovi-routes-private" {
	count                  = "${length(compact(split(",", var.destination_cidrs)))}"
    route_table_id         = "${aws_route_table.private.id}" 
    destination_cidr_block = "${element(compact(split(",", var.destination_cidrs)), count.index)}"
    gateway_id             = "${aws_vpn_gateway.vpn_gateway.id}"
    depends_on             = ["aws_route_table.private"]
}
