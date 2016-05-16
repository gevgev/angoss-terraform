/* Default security group */
resource "aws_security_group" "default" {
  name = "default-angoss-security-group"
  description = "Default security group that allows inbound and outbound traffic from all instances in the VPC"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  tags { 
    Name = "angoss-default-vpc" 
  }
}

/* Security group for the angoss server */
resource "aws_security_group" "angoss-app" {
  name = "app-angoss-security-group"
  description = "Security group for outbound HTTP[S]"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port     = 3389
    to_port       = 3389
    protocol      = "tcp"
    cidr_blocks   = [ "${values(var.rdp_access_cidrs)}" ]
  }

  ingress {
    from_port  = -1
    to_port    = -1
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
   from_port     = 1433
   to_port       = 1433
   protocol      = "tcp"
   cidr_blocks   = [ "172.16.77.22/32", "172.16.77.30/32" ]
  }

  egress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["10.198.0.0/16"]
  }

  tags { 
    Name = "app-angos" 
  }
}

/* using security rules forces the sg recreate
resource "aws_security_group_rule" "default-rdp-in" {
   type          = "ingress"
   from_port     = 3389
   to_port       = 3389
   protocol      = "tcp"
   cidr_blocks   = [ "${values(var.rdp_access_cidrs)}" ]
   security_group_id = "${aws_security_group.angoss-app.id}"
}

resource "aws_security_group_rule" "default-ms-sql-out" {
   type          = "egress"
   from_port     = 1433
   to_port       = 1433
   protocol      = "tcp"
   cidr_blocks   = [ "172.16.77.22/32", "172.16.77.30/32" ]
   security_group_id = "${aws_security_group.angoss-app.id}"
}
*/

/* Security group for the nat server */
resource "aws_security_group" "nat" {
  name = "nat-angoss-security-group"
  description = "Security group for nat instances that allows SSH/RDP and VPN traffic from internet. Also allows outbound HTTP[S]"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 1194
    to_port   = 1194
    protocol  = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port  = -1
    to_port    = -1
    protocol   = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags { 
    Name = "nat-angos" 
  }
  lifecycle {  prevent_destroy = true  }

}

/* Security group for the web */
resource "aws_security_group" "private" {
  name = "angoss-private-security-group"
  description = "Security group for web that allows web traffic from internet"
  vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port     = 3389
    to_port       = 3389
    protocol      = "tcp"
    cidr_blocks   = [ "${values(var.rdp_access_cidrs)}" ]
  }

  ingress {
    from_port     = 3389
    to_port       = 3389
    protocol      = "tcp"
    cidr_blocks   = ["10.198.0.0/16"]
  }

  ingress {
    from_port  = -1
    to_port    = -1
    protocol   = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
   from_port     = 1433
   to_port       = 1433
   protocol      = "tcp"
   cidr_blocks   = [ "172.16.77.22/32", "172.16.77.30/32" ]
  }
  egress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags { 
    Name = "angoss-private" 
  }
} 
