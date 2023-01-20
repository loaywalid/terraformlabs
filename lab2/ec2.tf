
resource "aws_security_group" "sec-group" {
  name        = "httpd-secgroup"
  description = "Security group for allowing "
  vpc_id     = aws_vpc.tflab2Vpc.id

 ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_instance" "lab2tf-ec2-terraform" {
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id      = aws_subnet.publicsubnet.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.sec-group.id]
  user_data = <<-EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apache2 -y
  EOF

  tags = {
    Name = "lab2tf terrafromec2"
  }
}

resource "aws_instance" "private-ec2" {
  ami                         = "ami-0b5eea76982371e91"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.privatesubnet.id
  vpc_security_group_ids            = [aws_security_group.sec-group.id]



  user_data = <<-EOF
  #!/bin/bash
  echo "***********************"
  yum update -y
  yum install -y httpd.x86_64
  systemctl start httpd.service
  systemctl enable httpd.service
  EOF

  tags = {
    Name = "tflab2privateinstance"
  }
}
