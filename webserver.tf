provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_key_pair" "Task1" {
  key_name   = "Task1"
  public_key = file("AWSKeyPub")
}


resource "aws_security_group" "Task1Web" {
  name        = "Web-security-group"
  description = "Allow HTTP, HTTPS and SSH traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform"
  }
}


resource "aws_instance" "Task1WebServer" {
  ami           = "ami-0823c236601fef765"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.Task1.key_name

  provisioner "file" {
    source      = "./httpdscript.sh"
    destination = "/tmp/script.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
	  "sudo chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }
  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
	private_key = file("AWSKeyPri")
    host        = self.public_ip
	}
  
  tags = {
    Name = "Task1WebServer"
  }

  vpc_security_group_ids = [
    aws_security_group.Task1Web.id
  ]

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 30
  }
}

resource "aws_eip" "Task1Web" {
  vpc      = true
  instance = aws_instance.Task1WebServer.id
}