resource "aws_vpc" "tflab2Vpc" {
    cidr_block = var.vpc-cidr
    tags = {
      "Name" = "tf lab2 vpc"
    }
}

resource "aws_subnet" "publicsubnet" {
  vpc_id     = aws_vpc.tflab2Vpc.id
  cidr_block = var.subnet-cidr[0]

  tags = {
    Name = "tflab2 publicsubnet"
  }
}

resource "aws_subnet" "privatesubnet" {
  vpc_id     = aws_vpc.tflab2Vpc.id
  cidr_block = var.subnet-cidr[1]

  tags = {
    Name = "tflab2 privatesubnet"
  }
}


resource "aws_internet_gateway" "tflab2GW" {
 vpc_id = aws_vpc.tflab2Vpc.id
 
 tags = {
   Name = "tflab2 internetgateway"
 }
}



resource "aws_route_table" "tflab2_rt" {
 vpc_id = aws_vpc.tflab2Vpc.id
 
 route {
   cidr_block = var.rt-cidr
   gateway_id = aws_internet_gateway.tflab2GW.id
 }
 
 tags = {
   Name = "tflab2 routetable"
 }
}





resource "aws_route_table_association" "tfpublicsubnetasso" {
 subnet_id      = aws_subnet.publicsubnet.id
 route_table_id = aws_route_table.tflab2_rt.id
}


resource "aws_eip" "ip" {
  vpc      = true
  tags = {
    Name = "tf-elasticIP"
  }
}


resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.publicsubnet.id
  tags = {
    Name = "lab2tf nat-gateway"
  }
}

resource "aws_route_table" "tfrouteTable-2" {
 vpc_id = aws_vpc.tflab2Vpc.id

  route {
    cidr_block = var.rt-cidr
    gateway_id = aws_nat_gateway.nat-gateway.id
  }

  tags = {
    Name = "t4routeTable-2"
  }
}

 resource "aws_route_table_association" "tflab2associate2" {
  subnet_id      = aws_subnet.privatesubnet.id
  route_table_id = aws_route_table.tfrouteTable-2.id
}
