resource "aws_security_group" "app_related" {
  vpc_id = var.vpc.id


  ingress {
    cidr_blocks = local.subnet_ids
    from_port   = 0
    to_port     = 0
    protocol    = -1
  }

  tags = {
    Name        = "${var.name}-${var.environment}-net-related-sg"
    Project     = var.name
    Environment = "prod"
  }
}
