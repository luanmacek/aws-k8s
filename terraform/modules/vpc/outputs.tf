output "vpc_id" {
  value = aws_vpc.this.id
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private : subnet.id]
}
