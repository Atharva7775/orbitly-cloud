output "endpoint" {
  value = aws_db_instance.this.address
}

output "port" {
  value = aws_db_instance.this.port
}

output "database_url" {
  description = "postgresql+psycopg URL in the format orbitly-backend expects for DATABASE_URL."
  value = format(
    "postgresql+psycopg://%s:%s@%s:%d/%s",
    var.username,
    random_password.master.result,
    aws_db_instance.this.address,
    aws_db_instance.this.port,
    var.database_name,
  )
  sensitive = true
}
