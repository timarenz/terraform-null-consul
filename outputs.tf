# output "encryption_key" {
#   description = "Encryption key that was automtacially generated"
#   value       = local.encryption_key
#   sensitive   = true
# }

output "id" {
  description = "Output variable to be used for other resources to depend on this module"
  value       = null_resource.complete.id
}

output "config" {
  description = "Consul configuration in HCL format"
  value       = local.config_file
}
