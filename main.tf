terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0005e0cfe09cc9050" 
  instance_type = "t2.micro"

  tags = {
    Name = "esmail instane"
  }
}