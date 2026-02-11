provider "aws"  {
    region = "us-east-1"
}

resource "aws_instance" "sevidor" {
  ami = "ami-0b6c6ebed2801a5cb"
  instance_type = "t3.micro"
  key_name = "projeto-devsecops"

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    name = "servidor-devsecops"
  }
}

resource "aws_security_group" "ssh" {
    name = "ssh"
    description = "Permitir SSH"

    ingress  {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["200.131.56.36/32"]
    }

    ingress  {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 19999
        to_port = 19999
        protocol = "tcp"
        cidr_blocks = ["200.131.56.36/32"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output "ip_publico" {
  value = aws_instance.sevidor.public_ip
}
