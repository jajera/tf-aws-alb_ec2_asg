variable "use_case" {
  default = "tf-aws-alb_ec2_asg"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_resourcegroups_group" "example" {
  name        = "tf-rg-example-${random_string.suffix.result}"
  description = "Resource group for example resources"

  resource_query {
    query = <<JSON
    {
      "ResourceTypeFilters": [
        "AWS::AllSupported"
      ],
      "TagFilters": [
        {
          "Key": "Owner",
          "Values": ["John Ajera"]
        },
        {
          "Key": "UseCase",
          "Values": ["${var.use_case}"]
        }
      ]
    }
    JSON
  }

  tags = {
    Name    = "tf-rg-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "tf-vpc-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name    = "tf-subnet-public1-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name    = "tf-subnet-public2-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "public3" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-1c"

  tags = {
    Name    = "tf-subnet-public3-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-southeast-1a"

  tags = {
    Name    = "tf-subnet-private1-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-southeast-1b"

  tags = {
    Name    = "tf-subnet-private2-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_subnet" "private3" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "ap-southeast-1c"

  tags = {
    Name    = "tf-subnet-private3-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name    = "tf-ig-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_eip" "example" {
  domain = "vpc"

  tags = {
    Name    = "tf-eip-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.example.id
  subnet_id     = aws_subnet.public1.id

  depends_on = [
    aws_internet_gateway.example
  ]

  tags = {
    Name    = "tf-ngw-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name    = "tf-rt-public"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name    = "tf-rt-private1"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_route_table" "private2" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name    = "tf-rt-private2"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_route_table" "private3" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
    Name    = "tf-rt-private3"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.private3.id
  route_table_id = aws_route_table.private3.id
}

resource "aws_security_group" "http_alb" {
  name        = "tf-sg-example_http_alb-${random_string.suffix.result}"
  description = "Security group for example resources to allow alb access to http"
  vpc_id      = aws_vpc.example.id

  ingress {
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
    Name    = "tf-sg-example_http_alb-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_security_group" "http_ec2" {
  name        = "tf-sg-example_http_ec2-${random_string.suffix.result}"
  description = "Security group for example resources to allow access to http hosted in ec2"
  vpc_id      = aws_vpc.example.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.http_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "tf-sg-example_http_ec2-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_lb" "example" {
  name                       = "tf-alb-example-${random_string.suffix.result}"
  internal                   = false
  load_balancer_type         = "application"
  enable_deletion_protection = false
  drop_invalid_header_fields = true
  idle_timeout               = 600

  security_groups = [
    aws_security_group.http_alb.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id,
    aws_subnet.public3.id
  ]

  tags = {
    Name    = "tf-alb-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_lb_target_group" "example" {
  name        = "tf-alb-tg-example-${random_string.suffix.result}"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.example.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    unhealthy_threshold = 2
    path                = "/"
  }

  tags = {
    Name    = "tf-alb-tg-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

resource "aws_lb_listener" "example" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example.arn
  }

  tags = {
    Name    = "tf-alb-listener-example-${random_string.suffix.result}"
    Owner   = "John Ajera"
    UseCase = var.use_case
  }
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true


  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_launch_template" "example" {
  name_prefix   = "lt-example-"
  ebs_optimized = true
  image_id      = data.aws_ami.amazon-linux-2.image_id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.http_ec2.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "tf-lt-example-${random_string.suffix.result}"
      Owner   = "John Ajera"
      UseCase = var.use_case
    }
  }

  user_data = filebase64("${path.module}/external/webserver.sh")
}

resource "aws_autoscaling_group" "example" {
  desired_capacity = 3
  max_size         = 6
  min_size         = 1

  vpc_zone_identifier = [
    aws_subnet.private1.id,
    aws_subnet.private2.id,
    aws_subnet.private3.id
  ]

  target_group_arns = [
    aws_lb_target_group.example.arn
  ]

  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "tf-asg-example"
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = "John Ajera"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "example" {
  name                   = "tf-autoscale-policy-example-${random_string.suffix.result}"
  scaling_adjustment     = 4
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.example.name
}

output "config" {
  value = {
    lb_url = "http://${aws_lb.example.dns_name}"
    eip    = aws_eip.example.public_ip
  }
}
