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
  engine                  = "postgres"
  engine_version          = var.postgres_engine
  db_subnet_group_name    = aws_db_subnet_group.this.name
  instance_class          = var.db_instance_class
  name                    = local.cluster_name
  username                = data.aws_ssm_parameter.db-root-username.value
  password                = data.aws_ssm_parameter.db-root-password.value
  parameter_group_name    = "default.postgresql${var.postgres_engine}"
  backup_retention_period = 30
}

/*
provider "postgresql" {
  host     = aws_db_instance.this.endpoint
  username = data.aws_ssm_parameter.db-root-username.value
  password = data.aws_ssm_parameter.db-root-password.value
  database = "postgres"
}

resource "postgresql_database" "app" {
  name = data.aws_ssm_parameter.db-dbname.value
}


resource "postgresql_role" "application_role" {
  name     = data.aws_ssm_parameter.db-app-username.value
  login    = true
  password = data.aws_ssm_parameter.db-app-password.value
}

resource "postgresql_grant" "appuser" {
  role        = data.aws_ssm_parameter.db-app-username.value
  database    = data.aws_ssm_parameter.db-dbname.value
  schema      = "public"
  object_type = "table"
  privileges  = ["ALL"]
}
*/
