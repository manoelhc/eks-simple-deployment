data "aws_ssm_parameter" "db-root-username" {
  name = "/${var.name}/${var.environment}/database/root-username/master"
}

data "aws_ssm_parameter" "db-root-password" {
  name = "/${var.name}/${var.environment}/database/root-password/master"
}

data "aws_ssm_parameter" "db-dbname" {
  name = "/${var.name}/${var.environment}/database/dbname/master"
}

data "aws_ssm_parameter" "db-app-username" {
  name = "/${var.name}/${var.environment}/database/username/master"
}

data "aws_ssm_parameter" "db-app-password" {
  name = "/${var.name}/${var.environment}/database/password/master"
}
