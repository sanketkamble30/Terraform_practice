provider "aws" {
    region = ""
  
}

# key pair
resource "aws_key_pair" "my_key" {
  key_name = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}


#vpc

resource "aws_default_vpc" "default" {
  
}

#security group

resource "aws_security_group" "my_security_group" {
    name = "automate-sg"
    description = "this is add a TF generated security group"
    vpc_id = aws_default_vpc.default.id   #interpolation
  
  #inbound rules
  ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #outboundr rule
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} 

# ec2
resource "aws_instance" "my_instance" {
    key_name = aws_key_pair.my_key.key_name
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = "t2.micro"
    ami = "ami-056335ec4a8783947" 

root_block_device {
  volume_size = 10
  volume_type = "gp3"
}

tags = {
  Name = "first-teraform"
    }
}
