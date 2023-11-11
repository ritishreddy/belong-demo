resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh" {
  key_name = "DemoMachine"
  public_key = tls_private_key.ssh.public_key_openssh
}

output "ssh_private_key_pem" {
  sensitive = true
  value = tls_private_key.ssh.private_key_pem
}

output "ssh_public_key_pem" {
  value = tls_private_key.ssh.public_key_pem
}

resource "aws_security_group" "securitygroup" {
  name = "DemoSecurityGroup"
  description = "DemoSecurityGroup"
  vpc_id = aws_vpc.vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  tags = {
    "Name" = "DemoSecurityGroup"
  }
}

resource "aws_instance" "ec2instance" {
  count = 2
  instance_type = "t2.micro"
  ami = "ami-07b5c2e394fccab6e" # https://cloud-images.ubuntu.com/locator/ec2/ (Ubuntu)
  subnet_id = aws_subnet.instance.id
  security_groups = [aws_security_group.securitygroup.id]
  key_name = aws_key_pair.ssh.key_name
  disable_api_termination = false
  ebs_optimized = false
  user_data     = file("init_script.sh")
  root_block_device {
    volume_size = "10"
  }
  tags = {
    "Name" = "BelongMachinePrivate"
  }
}

output "instance_private_ip" {
  value = aws_instance.ec2instance.private_ip
}
