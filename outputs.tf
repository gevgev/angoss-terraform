output "app.0.ip" {
  value = "${aws_instance.app.0.private_ip}"
}

output "app.1.ip" {
  value = "${aws_instance.app.1.private_ip}"
}

output "app-server.0.ip" {
  value = "${aws_instance.app-server.1.private_ip}"
}

output "app-server.1.ip" {
  value = "${aws_instance.app-server.1.private_ip}"
}

output "vpn_connection_id" {
  value = "${aws_vpn_connection.main.id}"
}

/*
output "nat.ip" {
  value = "${aws_instance.nat.public_ip}"
}
*/

/*
output "elb.hostname" {
  value = "${aws_elb.app.dns_name}"
}
*/