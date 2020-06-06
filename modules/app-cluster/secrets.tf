resource "aws_ssm_parameter" "db-root-username" {
  name        = "/${var.name}/${var.environment}/database/root-username/master"
  description = "${var.name} ${var.environment}'s Database Username"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-username")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-root-password" {
  name        = "/${var.name}/${var.environment}/database/root-password/master"
  description = "${var.name} ${var.environment}'s Database Password"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-password")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-dbname" {
  name        = "/${var.name}/${var.environment}/database/dbname/master"
  description = "${var.name} ${var.environment}'s Database DB Name"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-dbname")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}


/*
resource "aws_ssm_parameter" "db-hostname" {
  name        = "/${var.name}/${var.environment}/database/hostname/master"
  description = "${var.name} ${var.environment}'s Database Password"
  type        = "SecureString"
  value       = aws_db_instance.this.endpoint

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}
*/

resource "aws_ssm_parameter" "db-app-username" {
  name        = "/${var.name}/${var.environment}/database/username/master"
  description = "${var.name} ${var.environment}'s Database Username"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-app-username")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "db-app-password" {
  name        = "/${var.name}/${var.environment}/database/password/master"
  description = "${var.name} ${var.environment}'s Database Password"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-app-password")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}
