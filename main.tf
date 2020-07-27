provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "PyChainVPC" {
  cidr_block = "10.0.0.0/28"
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_subnet" "PyChainPubsub" {
  vpc_id                  = aws_vpc.PyChainVPC.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_security_group" "PyChainSG" {
  name   = "PyChain"
  vpc_id = aws_vpc.PyChainVPC.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["45.25.24.247/32"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["45.25.24.247/32"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["45.25.24.247/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_network_acl" "PyChainNACL" {
  vpc_id     = aws_vpc.PyChainVPC.id
  subnet_ids = [aws_subnet.PyChainPubsub.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "45.25.24.247/32"
    from_port  = 22
    to_port    = 22
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  ingress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  egress {
    protocol   = "tcp"
    rule_no    = 400
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_internet_gateway" "PyChainIGW" {
  vpc_id = aws_vpc.PyChainVPC.id
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_route_table" "PyChainRT" {
  vpc_id = aws_vpc.PyChainVPC.id
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}

resource "aws_route" "PyChainIGWAccess" {
  route_table_id         = aws_route_table.PyChainRT.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.PyChainIGW.id
}

resource "aws_route_table_association" "PyChainAssociation" {
  subnet_id      = aws_subnet.PyChainPubsub.id
  route_table_id = aws_route_table.PyChainRT.id
}

resource "aws_instance" "PyChainEC2" {
  ami                    = "ami-08f3d892de259504d"
  instance_type          = "t2.micro"
  key_name               = "jlh-pychain"
  iam_instance_profile   = "py_chain"
  vpc_security_group_ids = [aws_security_group.PyChainSG.id]
  subnet_id              = aws_subnet.PyChainPubsub.id
  tags = {
    Name     = "PyChain"
    Owner    = "Josh Hill"
    Email    = "joshua.hill@slalom.com"
    Manager  = "Reed Hanson"
    Market   = "Houston"
    Practice = "TE"
    Project  = "PyChain"
  }
}
