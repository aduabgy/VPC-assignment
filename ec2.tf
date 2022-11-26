resource "aws_instance" "Test-serve-1" {
  ami           = var.instance_type
  instance_type = var.ami
  availability_zone = var.AZ1
  tags = {
    Name = "Test-serve-1"
  }
}

resource "aws_instance" "Test-serve-2" {
  ami           = var.instance_type     
  instance_type = var.ami
  availability_zone = var.AZ2
  tags = {
    Name = "Test-serve-2"
  }
}
