resource "aws_security_group" "private_ec2_instance_eic" {
  name   = "${var.demo_application_name}-private-ec2-eice-sg"
  vpc_id = aws_vpc.example.id

  egress {
    from_port   = 22
    to_port     = 22
    description = "SSH for Instance Connect"
    security_groups = [
      aws_security_group.private_ec2_for_eic.id
    ]
    protocol = "tcp"
  }
}

resource "aws_security_group" "private_ec2_for_eic" {
  name   = "${var.demo_application_name}-private-ec2-for-eic-sg"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "private_ec2_for_eic_ingress" {
  security_group_id = aws_security_group.private_ec2_for_eic.id

  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  description              = "Access from EIC endpoint SG"
  source_security_group_id = aws_security_group.private_ec2_instance_eic.id
  protocol                 = "tcp"
}

resource "aws_instance" "private_for_eic" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  vpc_security_group_ids      = [aws_security_group.private_ec2_for_eic.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  tags = {
    Name = "${var.demo_application_name}-private-eic-ec2-instance"
  }
}
