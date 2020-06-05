data "aws_ssm_parameter" "db-hostname" {
  name = "/${var.name}/${var.environment}/database/hostname/master"
}

data "aws_ssm_parameter" "db-username" {
  name = "/${var.name}/${var.environment}/database/username/master"
}

data "aws_ssm_parameter" "db-password" {
  name = "/${var.name}/${var.environment}/database/password/master"
}

data "aws_ssm_parameter" "db-dbname" {
  name = "/${var.name}/${var.environment}/database/dbname/master"
}
