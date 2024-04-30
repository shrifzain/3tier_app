# Declare the provider (AWS in this case)
provider "aws" {
  region = "us-east-1"  # Set your desired AWS region
}

# Create a key pair for SSH access
resource "aws_key_pair" "my_key_pair" {
  key_name   = "key"  # Replace with your desired key pair name
  public_key = file("~/.ssh/id_rsa.pub")  # Replace with the path to your public key
}

# Create IAM Role for EC2 instance
# resource "aws_iam_role" "jenkins_ec2_role" {
#   name = "jenkins_ec2_role"
#   assume_role_policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Effect" : "Allow",
#         "Principal" : {
#           "Service" : "ec2.amazonaws.com"
#         },
#         "Action" : "sts:AssumeRole"
#       }
#     ]
#   })
# }


# Attach Policy for AmazonEC2ContainerRegistryReadOnly to IAM Role
#resource "aws_iam_role_policy_attachment" "ecr_readonly_policy_attachment" {
#  role       = aws_iam_role.jenkins_ec2_role.name
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#}



# Attach Policy for AmazonEC2ContainerRegistryFullAccess to IAM Role
# resource "aws_iam_role_policy_attachment" "ecr_full_access_policy_attachment" {
#   role       = aws_iam_role.jenkins_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
# }

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "MyVPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "MyInternetGateway"
  }
}

# Create Public Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "MyPublicSubnet"
  }
}

# Create Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "MyRouteTable"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create Security Group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MySecurityGroup"
  }
}

# Define the EC2 instance
resource "aws_instance" "ec2_jenkins" {
  ami           = "ami-07caf09b362be10b8" # ubuntu
  instance_type = "t2.micro"                # Instance type (change as needed)
  subnet_id     = aws_subnet.my_subnet.id
   key_name       = aws_key_pair.my_key_pair.key_name
  security_groups = [aws_security_group.my_security_group.id]
  associate_public_ip_address = true  # Assign a public IP address to the instance
  
  tags = {
    Name = "ec2_jenkins"                # Name tag for the instance
  }
}


output "public_ip" {
  value = aws_instance.ec2_jenkins.public_ip
}
