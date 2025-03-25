output "private_subnets" {
  value = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "eks_sg" {
  value = aws_security_group.eks_sg.id
}