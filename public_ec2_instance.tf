resource "aws_security_group" "public_ec2_instance" {
  name   = "${var.demo_application_name}-public-ec2-sg"
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    description = "Access from my IP via SSH"
    cidr_blocks = ["${local.my_ip}/32"]
    protocol    = "tcp"
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids      = [aws_security_group.public_ec2_instance.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair_name

  tags = {
    Name = "${var.demo_application_name}-public-ec2-instance"
  }
}
