#Create a new VPC. 
resource "aws_vpc" "vpc1" {
    cidr_block = "172.31.0.0/16"
    instance_tenancy = "default"
    tags = {
     Name = "Terraform_vpc1"
     Team = "DevOps"
     env = "Dev"
    }
}
#Create an Internet Gateway
resource "aws_internet_gateway" "gtw1" {
    vpc_id = aws_vpc.vpc1.id
}

#Public subnet 1
resource "aws_subnet" "public_subnet1" {
    availability_zone = "us-east-2a"
    cidr_block = "172.31.1.0/24"
    vpc_id = aws_vpc.vpc1.id
    map_public_ip_on_launch = true
    tags={
        Name = "Public_subnet1"

    }
}
#Public subnet 2
resource "aws_subnet" "public_subnet2" {
    availability_zone = "us-east-2b"
    cidr_block = "172.31.2.0/24"
    vpc_id = aws_vpc.vpc1.id
    map_public_ip_on_launch = true
    tags={
        Name = "Public_subnet2"

    }
} 
#Private subnet 1 
resource "aws_subnet" "private_subnet1" {
    availability_zone = "us-east-2a"
    cidr_block = "172.31.3.0/24"
    vpc_id = aws_vpc.vpc1.id
}
#Private subnet 2 
resource "aws_subnet" "private_subnet2" {
    availability_zone = "us-east-2b"
    cidr_block = "172.31.4.0/24"
    vpc_id = aws_vpc.vpc1.id
}
#Elastic IP
resource "aws_eip" "elastic_ip" {    
}
#NAT Gateway
resource "aws_nat_gateway" "natgtw1" {
    allocation_id = aws_eip.elastic_ip.id
    subnet_id = aws_subnet.public_subnet1.id
}
#Public route table
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gtw1.id
    }
}
#Private route table
resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.vpc1.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgtw1.id
    }
}
#Route table Association with public subnets
resource "aws_route_table_association" "public_association1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public_route.id
}
resource "aws_route_table_association" "public_association2" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public_route.id
}
#Route table Association with private subnets
resource "aws_route_table_association" "private_association1" {
    subnet_id = aws_subnet.private_subnet1.id
    route_table_id = aws_route_table.private_route.id
}
resource "aws_route_table_association" "private_association2" {
    subnet_id = aws_subnet.private_subnet2.id
    route_table_id = aws_route_table.private_route.id
}
