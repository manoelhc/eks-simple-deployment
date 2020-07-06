resource "aws_db_subnet_group" "this" {
  name       = local.cluster_name
  subnet_ids = var.data_subnets

  tags = {
    Name = local.cluster_name
  }
}

resource "aws_db_instance" "this" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "postgres"
  engine_version            = var.postgres_engine
  db_subnet_group_name      = aws_db_subnet_group.this.name
  instance_class            = var.db_instance_class
  name                      = var.name
  identifier                = "${var.name}-${var.environment}"
  username                  = aws_ssm_parameter.db-root-username.value
  password                  = aws_ssm_parameter.db-root-password.value
  parameter_group_name      = "default.postgres${var.postgres_engine}"
  backup_retention_period   = 30
  multi_az                  = true
  final_snapshot_identifier = "${var.name}-final-snapshot-${random_string.db-final-snapshot.result}"
}

/*
provider "postgresql" {
  host     = aws_db_instance.this.endpoint
  username = aws_ssm_parameter.db-root-username.value
  password = aws_ssm_parameter.db-root-password.value
  database = "postgres"
}

resource "postgresql_database" "app" {
  name = aws_ssm_parameter.db-dbname.value
}

resource "postgresql_role" "application_role" {
  name     = aws_ssm_parameter.db-app-username.value
  login    = true
  password = aws_ssm_parameter.db-app-password.value
}

resource "postgresql_grant" "appuser" {
  role        = aws_ssm_parameter.db-app-username.value
  database    = aws_ssm_parameter.db-dbname.value
  schema      = "public"
  object_type = "table"
  privileges  = ["ALL"]
}

*/
