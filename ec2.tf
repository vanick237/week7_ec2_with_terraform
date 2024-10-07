resource "aws_instance" "server1" {
  ami           = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public_subnet1.id
  # security_groups = [aws_security_group.sg-demo.name]
  vpc_security_group_ids = [aws_security_group.sg-demo.id]
  key_name      = aws_key_pair.aws_key.key_name
  user_data     = file("server.sh")
  tags ={
    Name = "My_Terraform_VM"
  }
}