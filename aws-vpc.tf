/* Setup our aws provider */
provider "aws" {
  access_key  = "${var.access_key}"
  secret_key  = "${var.secret_key}"
  region      = "${var.region}"
}

/* Define our vpc */
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  tags { 
    Name = "angoss-group" 
  }
}

/* Routing table */
resource "aws_route_table" "rt-main" {
    vpc_id = "${aws_vpc.default.id}"
}