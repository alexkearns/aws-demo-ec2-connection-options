resource "aws_security_group" "private_ec2_instance_ssm" {
  name   = "${var.demo_application_name}-private-ssm-ec2-sg"
  vpc_id = aws_vpc.example.id

  egress {
    from_port   = 443
    to_port     = 443
    description = "VPC endpoints"
    security_groups = [
      aws_security_group.vpc_endpoints.id
    ]
    protocol = "tcp"
  }
}

resource "aws_security_group" "vpc_endpoints" {
  name   = "${var.demo_application_name}-vpce-sg"
  vpc_id = aws_vpc.example.id
}

resource "aws_security_group_rule" "vpc_endpoints_ingress" {
  security_group_id = aws_security_group.vpc_endpoints.id

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  description              = "Private EC2 instances"
  source_security_group_id = aws_security_group.private_ec2_instance_ssm.id
  protocol                 = "tcp"
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.example.id
  service_name      = "com.amazonaws.eu-west-1.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids = [aws_subnet.private.id]
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.demo_application_name}-ssm-vpce"
  }
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.example.id
  service_name      = "com.amazonaws.eu-west-1.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [aws_subnet.private.id]
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.demo_application_name}-ssmmessages-vpce"
  }
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id            = aws_vpc.example.id
  service_name      = "com.amazonaws.eu-west-1.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids = [aws_subnet.private.id]
  security_group_ids = [
    aws_security_group.vpc_endpoints.id,
  ]

  private_dns_enabled = true

  tags = {
    Name = "${var.demo_application_name}-ec2messages-vpce"
  }
}

resource "aws_iam_role" "private_for_ssm" {
  name = "${var.demo_application_name}-instance-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

resource "aws_iam_instance_profile" "private_for_ssm" {
  name = "${var.demo_application_name}-instance-profile"
  role = aws_iam_role.private_for_ssm.name
}

resource "aws_instance" "private_for_ssm" {
  ami                  = data.aws_ami.al2023.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.private_for_ssm.name

  vpc_security_group_ids      = [aws_security_group.private_ec2_instance_ssm.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  tags = {
    Name = "${var.demo_application_name}-private-ssm-ec2-instance"
  }
}
