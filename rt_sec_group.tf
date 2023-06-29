 resource "aws_internet_gateway" "gw" {
   vpc_id = resource.aws_vpc.my_vpc.id

   tags = {
     Name = "my_IG"
  }

 }

 resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.my_vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = resource.aws_internet_gateway.gw.id
  }

   tags = {
     Name = "new_public_rt"
  }
 }

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.my_subnet_1.id
  route_table_id = resource.aws_route_table.rtb_public.id
}

resource "aws_security_group" "my_security_group" {
  name = "my-security-group"
  description = "My Security Group"

  vpc_id = aws_vpc.my_vpc.id

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

    egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 
}