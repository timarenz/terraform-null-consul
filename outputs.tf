output "encryption_key" {
  description = "Encryption key that was automtacially generated"
  value       = local.encryption_key
  sensitive   = true
}

output "id" {
  description = "Output variable to be used for other resources to depend on this module"
  value       = null_resource.complete.id
}

output "consul_config_json" {
  description = ""
  value       = local.config_file_json
}

output "consul_config_hcl" {
  value = local.config_file_hcl
}
