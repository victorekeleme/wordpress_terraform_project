# Firstly create a random generated password to use in secrets.

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_password" "random_chars" {
  length           = 8
  special          = true
  override_special = "_%@"
}

# Creating a AWS secret for database
resource "aws_secretsmanager_secret" "db_credentials" {
  name = "db_credentials-${random_password.random_chars.result}"
}

# Creating a AWS secret versions for database master account
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = <<EOF
   {
    "username": "admin",
    "password": "${random_password.password.result}"
   }
EOF
}

# Importing the AWS secrets created previously using arn.
data "aws_secretsmanager_secret" "db_credentials" {
  arn = aws_secretsmanager_secret.db_credentials.arn
}

# Importing the AWS secret version created previously using arn.
data "aws_secretsmanager_secret_version" "db_credentials_sv" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.arn
}

# After importing the secrets storing into Locals
locals {
  db_credentials = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_sv.secret_string)
}