variable "dependencies" {
  type    = list(string)
  default = null
}

variable "host" {
  description = "IP address, hostname or dns name of the machine that should become a Consul agent"
  type        = string
}

variable "username" {
  description = "Username used for SSH connection"
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private key used for SSH connection"
  type        = string
}

variable "consul_binary" {
  description = "Path to Consul binary that should be uploaded. If not specified a version will be download from releases.hashicorp.com"
  type        = string
  default     = null
}

variable "consul_version" {
  description = "If specified this version will be downloaded from releases.hashicorp.com, if not the latest version will be used"
  type        = string
  default     = null
}

variable "dc_name" {
  description = "Name of the Consul datacenter"
  type        = string
  default     = "dc1"
}

variable "gossip_encryption" {
  description = "Specifies if gossip encryption should be used."
  type        = bool
  default     = false
}

variable "gossip_encryption_key" {
  description = "Allows to specify an existing gossip key. If not specified one will be generated."
  type        = string
  default     = null
}

variable "ui" {
  description = "Enable/disable Consul UI"
  type        = bool
  default     = true
}

variable "bootstrap_expect" {
  description = "Number of Consul server agents required to form a cluster"
  type        = number
  default     = 1
}

variable "bind_address" {
  description = "IP address the Consul agent should be bind to. go-sockaddr templates are supported."
  type        = string
  default     = "{{ GetPrivateIP }}"
}

variable "retry_join" {
  description = "List of Consul server agents to form a cluster, cloud join syntax can also be used. "
  type        = list(string)
}

variable "tls" {
  description = "For future use"
  type        = bool
  default     = false
}

variable "data_dir" {
  description = "Consul data directory location"
  type        = string
  default     = "/opt/consul"
}

variable "ca_cert" {
  description = "For future use"
  type        = string
  default     = null
}

variable "tls_cert" {
  description = "For future use"
  type        = string
  default     = null
}

variable "tls_key" {
  description = "For future use"
  type        = string
  default     = null
}

variable "agent_type" {
  description = "Specify if the agent should become a server or client. Supported values: client or server"
  type        = string
  default     = "server"
}

variable "connect" {
  description = "Enable / disable Consul connect"
  type        = bool
  default     = false
}
