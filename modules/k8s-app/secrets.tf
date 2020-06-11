resource "random_string" "db-final-snapshot" {
  length  = 5
  special = false
  upper   = false
  number  = true
}


resource "random_string" "db-root-username" {
  length  = 10
  special = false
  upper   = false
  number  = true
}

resource "random_password" "db-root-password" {
  length  = 16
  special = false
  upper   = true
  number  = true
}

resource "random_string" "db-app-username" {
  length  = 10
  special = false
  upper   = false
  number  = false
}

resource "random_password" "db-app-password" {
  length  = 16
  special = false
  upper   = true
  number  = true
}

resource "random_string" "dbname" {
  length  = 10
  special = false
  upper   = false
  number  = true
}

resource "aws_ssm_parameter" "db-root-username" {
  name        = "/${var.name}/${var.environment}/database/root-username/master"
  description = "${var.name} ${var.environment}'s Database Username"
  type        = "SecureString"
  value       = "u${random_string.db-root-username.result}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-root-password" {
  name        = "/${var.name}/${var.environment}/database/root-password/master"
  description = "${var.name} ${var.environment}'s Database Password"
  type        = "SecureString"
  value       = "p${random_password.db-root-password.result}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-dbname" {
  name        = "/${var.name}/${var.environment}/database/dbname/master"
  description = "${var.name} ${var.environment}'s Database DB Name"
  type        = "SecureString"
  value       = "d${random_string.dbname.result}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-app-username" {
  name        = "/${var.name}/${var.environment}/database/username/master"
  description = "${var.name} ${var.environment}'s Database Username"
  type        = "SecureString"
  value       = "u${random_string.db-app-username.result}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-app-password" {
  name        = "/${var.name}/${var.environment}/database/password/master"
  description = "${var.name} ${var.environment}'s Database Password"
  type        = "SecureString"
  value       = "p${random_password.db-app-password.result}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}
