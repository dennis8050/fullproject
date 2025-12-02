output "vpc_id" { value = aws_vpc.main.id }
output "public_subnet_ids" { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
output "nat_gateway_ids" { value = aws_nat_gateway.natgw[*].id }
output "igw_id" { value = aws_internet_gateway.igw.id }
