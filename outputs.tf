
output "config_file" {
  value = local.config_file
}

output "encryption_key" {
  value     = local.encryption_key
  sensitive = true
}

output "id" {
  value = null_resource.configure.id
}
