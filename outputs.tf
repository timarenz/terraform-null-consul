
output "config_file" {
  value = local.config_file
}

output "gossip_encryption_key" {
  value     = local.gossip_encryption_key
  sensitive = true
}
