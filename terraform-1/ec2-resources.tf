resource "aws_instance" "webserver" {
    ami = data.aws_ami.ubuntu.id

    instance_type = "t2.micro"
    # VPC
    subnet_id = "${aws_subnet.subnet-public-1.id}"
    # Security Group
    vpc_security_group_ids = [ aws_security_group.allow_ssh_http_jenkins.id ]

tags = {
    Name = "webserver"
  }
}
