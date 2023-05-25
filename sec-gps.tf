

resource "aws_security_group" "Test-sec-group" {
  name        = "allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.Prod-rock-VPC.id

  ingress {
    description = "security group with ingress HTTP port open"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    description = "security group with ingress SSH port open"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_HTTP"
  }
}
