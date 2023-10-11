resource "aws_route_table" "rt_public" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "public_subnet" {
  count          = length(aws_subnet.subnet.*.id)
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rt_public.id
}