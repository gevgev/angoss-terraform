resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "${file(\"ssh/insecure-deployer.pub\")}"
}

resource "aws_key_pair" "deployer-daas" {
  key_name = "daas-deployer-key"
  public_key = "${file(\"ssh/daas-deployer-key.pub\")}"
}
