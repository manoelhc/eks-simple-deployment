resource "aws_ssm_parameter" "mysql-root-username" {
  name        = "/${var.name}/${var.environment}/database/username/master"
  description = "${var.name} ${var.environment}'s MySQL Username"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-username")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "mysql-root-password" {
  name        = "/${var.name}/${var.environment}/database/password/master"
  description = "${var.name} ${var.environment}'s MySQL Password"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-password")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "mysql-dbname" {
  name        = "/${var.name}/${var.environment}/dbname/username/master"
  description = "${var.name} ${var.environment}'s MySQL DB Name"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-root-dbname")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "mysql-hostname" {
  name        = "/${var.name}/${var.environment}/database/password/master"
  description = "${var.name} ${var.environment}'s MySQL Password"
  type        = "SecureString"
  value       = aws_db_instance.this.endpoint

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}


resource "aws_ssm_parameter" "mysql-app-username" {
  name        = "/${var.name}/${var.environment}/database/username/master"
  description = "${var.name} ${var.environment}'s MySQL Username"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-app-username")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}

resource "aws_ssm_parameter" "mysql-app-password" {
  name        = "/${var.name}/${var.environment}/database/password/master"
  description = "${var.name} ${var.environment}'s MySQL Password"
  type        = "SecureString"
  value       = "${base64sha256("${timestamp()}-app-password")}"

  tags = {
    appname     = "${var.name}"
    environment = "${var.environment}"
  }
}
