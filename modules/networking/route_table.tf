# Every VPC has a default route table that can be managed but not destroyed.
resource "aws_default_route_table" "rt_public" {
  default_route_table_id = aws_vpc.main.default_route_table_id
}

# resource "aws_route_table" "rt_public" {
#     vpc_id = aws_vpc.main.id

#     tags = {
#       Name = "${var.proj_name}-RT-public"
#     }
# }

resource "aws_route_table_association" "public_subnet" {
  count          = length(aws_subnet.subnet.*.id)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  # route_table_id = aws_route_table.rt_public.id
  route_table_id = aws_default_route_table.rt_public.id
}

resource "aws_route" "route_to_igw" {
  # route_table_id = aws_route_table.rt_public.id
  route_table_id = aws_default_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}