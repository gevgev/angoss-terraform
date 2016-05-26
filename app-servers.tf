/* App servers */
resource "aws_instance" "app" {
  count = 0
  ami = "${lookup(var.amis-win, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.angoss-app.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = { 
    Name = "angoss-server-app-${count.index}"
  }
}

resource "aws_instance" "app-server" {
  count = 0
  ami = "${lookup(var.amis-win-sql, var.region)}"
  instance_type = "m4.xlarge"
  subnet_id = "${aws_subnet.public.id}"
  vpc_security_group_ids = ["${aws_security_group.angoss-app.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  tags = { 
    Name = "angoss-server-sql-app-${count.index}"
  }
}

resource "aws_ebs_volume" "app-server-volume" {
    count = 0
    /* availability_zone = "${var.region}" */
    availability_zone = "us-west-2a"
    size = 1024
    tags {
        Name = "App-HDD-${count.index}"
    }
}

resource "aws_volume_attachment" "ebs_att" {
  count = 0
  device_name = "xvdb"
  volume_id = "${aws_ebs_volume.app-server-volume.id}"
  instance_id = "${aws_instance.app-server.id}"
}

/* -------- DaaS --------- */

/* App servers */
resource "aws_instance" "app-daas" {
  count = 0
  ami = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private-daas.id}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  key_name = "${aws_key_pair.deployer-daas.key_name}"
  source_dest_check = false
  /* the user_data installs Docker
  user_data = "${file(\"cloud-config/app.yml\")}"
  */
  tags = { 
    Name = "daas-app-${count.index}"
  }
}


/* App servers *
resource "aws_instance" "app-p" {
  count = 0
  ami = "${lookup(var.amis-win, var.region)}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.private.id}"
  vpc_security_group_ids = ["${aws_security_group.private.id}"]
  key_name = "${aws_key_pair.deployer.key_name}"
  source_dest_check = false
  user_data = "${file(\"cloud-config/app.yml\")}"
  tags = { 
    Name = "angoss-app-p-${count.index}"
  }
}
*/


/* Load balancer *
resource "aws_elb" "app" {
  name = "airpair-example-elb"
  subnets = ["${aws_subnet.public.id}"]
  security_groups = ["${aws_security_group.default.id}", "${aws_security_group.web.id}"]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = ["${aws_instance.app.*.id}"]
}
*/