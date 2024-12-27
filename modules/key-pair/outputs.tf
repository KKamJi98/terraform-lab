output "key_pair_name" {
  description = "The name of the Key Pair"
  value       = aws_key_pair.this.key_name
}

output "key_pair_value" {
  description = "The value of the Key Pair"
  value       = tls_private_key.this.private_key_pem
}