provider "aws" {
  profile = "turing-admin"
  region = "eu-west-3"
}

resource "aws_s3_bucket" "pip" {
  bucket = "pip-bucket.com"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:*"
            ],
            "Resource": [
                "arn:aws:s3:::pip-bucket.com/*"
            ]
        }
    ]
}
  EOF

  website {
    index_document = "index.html"
  }
}

# resource "aws_vpc" "azzurri-vpc" {
#     cidr_block       = "10.0.0.0/16"
#     instance_tenancy = "default"

#     tags = {
#         Name = "azzurri-vpc-new"
#     }
# }

# resource "aws_internet_gateway" "azzurri-gateway" {
#     vpc_id = aws_vpc.azzurri-vpc.id

#     tags = {
#         Name = "azzurri-internet-gateway"
#     }
# }

# resource "aws_subnet" "public-a" {
#     vpc_id     = aws_vpc.azzurri-vpc.id
#     cidr_block = "10.0.0.0/17"
#     availability_zone = "eu-west-3a"

#     tags = {
#         Name = "azzurri-public-a"
#     }
# }

# resource "aws_subnet" "public-b" {
#     vpc_id     = aws_vpc.azzurri-vpc.id
#     cidr_block = "10.0.128.0/17"
#     availability_zone = "eu-west-3b"

#     tags = {
#         Name = "azzurri-public-b"
#     }
# }

# # resource "aws_subnet" "private-a" {
# #     vpc_id     = aws_vpc.azzurri-vpc.id
# #     cidr_block = "10.0.128.0/17"
# #     availability_zone = "eu-west-3a"

# #     tags = {
# #         Name = "azzurri-private-a"
# #     }
# # }

# resource "aws_eip" "azzurri-eip" {
#     vpc      = true
# }

# resource "aws_nat_gateway" "azzurri-nat-gateway" {
#     allocation_id = aws_eip.azzurri-eip.id
#     subnet_id = aws_subnet.public-a.id
#     depends_on = [aws_internet_gateway.azzurri-gateway]
# }

# resource "aws_route_table" "public-route-table" {
#     vpc_id = aws_vpc.azzurri-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.azzurri-gateway.id
#     }
    

#     tags = {
#         Name = "azzurri-public-route-table"
#     }
# }

# resource "aws_route_table" "private-route-table" {
#     vpc_id = aws_vpc.azzurri-vpc.id

#     route {
#         cidr_block = "0.0.0.0/0"
#         nat_gateway_id = aws_nat_gateway.azzurri-nat-gateway.id
#     }

#     tags = {
#         Name = "azzurri-private-route-table"
#     }
# }

# resource "aws_route_table_association" "public-a-association" {
#     subnet_id = aws_subnet.public-a.id
#     route_table_id = aws_route_table.public-route-table.id
# }

# resource "aws_route_table_association" "public-b-association" {
#     subnet_id = aws_subnet.public-b.id
#     route_table_id = aws_route_table.public-route-table.id
# }

# # resource "aws_route_table_association" "private-a-association" {
# #     subnet_id = aws_subnet.private-a.id
# #     route_table_id = aws_route_table.private-route-table.id
# # }

# resource "aws_instance" "azzurri-instance" {
#     ami           = "ami-00bf323ac99d8bbbb"
#     instance_type = "t3.micro"
#     key_name = "pippa-ec2"
#     associate_public_ip_address = true
#     subnet_id = aws_subnet.public-a.id
#     vpc_security_group_ids = [aws_security_group.azzurri-security-group.id]
#     user_data = <<EOF
# #! /bin/bash
# sudo yum update -y
# sudo yum install -y httpd
# sudo systemctl start httpd
# sudo echo 'Hello World!' > /var/www/html/index.html
# EOF

#     tags = {
#         Name = "azzurri-ec2-pip"
#     }
# }

# resource "aws_instance" "azzurri-instance-2" {
#     ami           = "ami-00bf323ac99d8bbbb"
#     instance_type = "t3.micro"
#     key_name = "pippa-ec2"
#     associate_public_ip_address = true
#     subnet_id = aws_subnet.public-b.id
#     vpc_security_group_ids = [aws_security_group.azzurri-security-group.id]
#     user_data = <<EOF
# #! /bin/bash
# sudo yum update -y
# sudo yum install -y httpd
# sudo systemctl start httpd
# sudo echo 'Hello World! - 2' > /var/www/html/index.html
# EOF

#     tags = {
#         Name = "azzurri-ec2-pip-2"
#     }
# }

# resource "aws_security_group" "azzurri-security-group" {
#   name        = "azzurri-security-group"
#   vpc_id      = aws_vpc.azzurri-vpc.id

#   ingress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "azzurri-security-group"
#   }
# }

# resource "aws_elb" "azzurri-elb" {
#   name               = "azzurri-elb"
#   subnets = [aws_subnet.public-a.id, aws_subnet.public-b.id]
#   security_groups = [aws_security_group.azzurri-security-group.id]

#   listener {
#     instance_port     = 8000
#     instance_protocol = "TCP"
#     lb_port           = 80
#     lb_protocol       = "TCP"
#   }

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     target              = "TCP:80"
#     interval            = 30
#   }

#   instances                   = [aws_instance.azzurri-instance.id, aws_instance.azzurri-instance-2.id]
#   cross_zone_load_balancing   = true
#   idle_timeout                = 400
#   connection_draining         = true
#   connection_draining_timeout = 400

#   tags = {
#     Name = "azzurri-elb"
#   }
# }