resource "aws_subnet" "subnet" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index) # 30.0.X.0/24 mask for each subnet if vpc cidr block prefix is /16
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)
}

