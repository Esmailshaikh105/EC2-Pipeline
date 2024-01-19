provider "aws" {
  region     = "us-east-1"
  access_key = "AKIATV55UTOKQBJJEJWX"
  secret_key = "mudIEpdy0DIgTWxURDeqylQwFlSShYIxA/JdyeSA"
}

resource "aws_instance" "example" {
  ami           = "ami-0005e0cfe09cc9050" 
  instance_type = "t2.micro"

  tags = {
    Name = "esmail instane"
  }
}
