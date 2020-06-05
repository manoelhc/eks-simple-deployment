resource "aws_db_subnet_group" "this" {
  name       = "${local.cluster_name}"
  subnet_ids = local.data_subnet_ids

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_db_instance" "this" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = var.mysql_engine
  db_subnet_group_name    = aws_db_subnet_group.this.name
  instance_class          = var.db_instance_class
  name                    = local.cluster_name
  username                = aws_ssm_parameter.mysql-root-username.value
  password                = aws_ssm_parameter.mysql-root-password.value
  parameter_group_name    = "default.mysql${var.mysql_engine}"
  backup_retention_period = 30
}

provider "mysql" {
  endpoint = aws_db_instance.this.endpoint
  username = aws_ssm_parameter.mysql-root-username.value
  password = aws_ssm_parameter.mysql-root-password.value
}

resource "mysql_database" "app" {
  name = aws_ssm_parameter.mysql-dbname.value
}

resource "mysql_user" "appuser" {
  user               = aws_ssm_parameter.mysql-app-username.value
  host               = "%"
  plaintext_password = aws_ssm_parameter.mysql-app-password.value
}

resource "mysql_grant" "appuser" {
  user       = aws_ssm_parameter.mysql-app-username.value
  host       = "%"
  database   = aws_ssm_parameter.mysql-dbname.value
  privileges = ["ALL"]
}
