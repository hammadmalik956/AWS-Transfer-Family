output "transfer_server_endpoint" {
  value = element(concat(aws_transfer_server.this.*.endpoint, [""]), 0)
}

output "transfer_server_id" {
  value = element(concat(aws_transfer_server.this.*.id, [""]), 0)
}
