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

variable "datacenter" {
  description = "This flag controls the datacenter in which the agent is running. If not provided, it defaults to 'dc1'. Consul has first-class support for multiple datacenters, but it relies on proper configuration. Nodes in the same datacenter should be on a single LAN. (https://www.consul.io/docs/agent/options.html#_datacenter)"
  type        = string
  default     = "dc1"
}

variable "data_dir" {
  description = "This flag provides a data directory for the agent to store state. This is required for all agents. The directory should be durable across reboots. (https://www.consul.io/docs/agent/options.html#_data_dir)"
  type        = string
  default     = "/opt/consul"
}

variable "agent_type" {
  description = "This flag is used to control if an agent is in server or client mode. Supported values: client or server. (https://www.consul.io/docs/agent/options.html#_server)"
  type        = string
  default     = "server"
}

variable "log_level" {
  description = "The level of logging to show after the Consul agent has started. This defaults to 'translate_wan_addrsinfo'translate_wan_addrs. The available log levels are 'translate_wan_addrstrace'translate_wan_addrs, 'translate_wan_addrsdebug'translate_wan_addrs, 'translate_wan_addrsinfo'translate_wan_addrs, 'translate_wan_addrswarn'translate_wan_addrs, and 'translate_wan_addrserr'translate_wan_addrs. (https://www.consul.io/docs/agent/options.html#_log_level)"
  type        = string
  default     = "info"
}

variable "encryption" {
  description = "Specifies the secret key to use for encryption of Consul network traffic. This key must be 16-bytes that are Base64-encoded. (https://www.consul.io/docs/agent/options.html#_encrypt)"
  type        = bool
  default     = false
}

variable "encryption_key" {
  description = "Allows to specify an existing gossip key. If not specified one will be generated."
  type        = string
  default     = null
}

variable "ui" {
  description = "Enables the built-in web UI server and the required HTTP routes. (https://www.consul.io/docs/agent/options.html#_ui)"
  type        = bool
  default     = true
}

variable "bootstrap" {
  description = "This flag is used to control if a server is in 'bootstrap' mode. (https://www.consul.io/docs/agent/options.html#_bootstrap_expect)"
  type        = bool
  default     = true
}

variable "bootstrap_expect" {
  description = "This flag provides the number of expected servers in the datacenter. (https://www.consul.io/docs/agent/options.html#_bootstrap_expect)"
  type        = number
  default     = 1
}

variable "retry_join" {
  description = "Similar to -join but allows retrying a join if the first attempt fails. This is useful for cases where you know the address will eventually be available. The list can contain IPv4, IPv6, or DNS addresses. (https://www.consul.io/docs/agent/options.html#retry-join)"
  type        = list(string)
}

variable "bind_addr" {
  description = "The address that should be bound to for internal cluster communications. This is an IP address that should be reachable by all other nodes in the cluster. (https://www.consul.io/docs/agent/options.html#_bind)"
  type        = string
  default     = null
}

variable "serf_lan" {
  description = "The address that should be bound to for Serf LAN gossip communications. This is an IP address that should be reachable by all other LAN nodes in the cluster. (https://www.consul.io/docs/agent/options.html#_serf_lan_bind)"
  type        = string
  default     = null
}

variable "serf_wan" {
  description = "The address that should be bound to for Serf WAN gossip communications. (https://www.consul.io/docs/agent/options.html#_serf_wan_bind)"
  type        = string
  default     = null
}

variable "advertise_addr" {
  description = "The advertise address is used to change the address that we advertise to other nodes in the cluster. By default, the -bind address is advertised. (https://www.consul.io/docs/agent/options.html#_advertise)"
  type        = string
  default     = null
}

variable "advertise_addr_wan" {
  description = "The advertise WAN address is used to change the address that we advertise to server nodes joining through the WAN. This can also be set on client agents when used in combination with the translate_wan_addrs configuration option. (https://www.consul.io/docs/agent/options.html#_advertise-wan)"
  type        = string
  default     = null
}

variable "translate_wan_addrs" {
  description = "If set to true, Consul will prefer a node's configured WAN address when servicing DNS and HTTP requests for a node in a remote datacenter."
  type        = bool
  default     = false
}

variable "dns_port" {
  description = "The DNS server, -1 to disable. Default 8600. TCP and UDP. (https://www.consul.io/docs/agent/options.html#dns_port)"
  type        = number
  default     = 8600
}

variable "http_port" {
  description = "The HTTP API, -1 to disable. Default 8500. TCP only. (https://www.consul.io/docs/agent/options.html#http_port)"
  type        = number
  default     = 8500
}

variable "https_port" {
  description = "The HTTPS API, -1 to disable. Default -1 (disabled). We recommend using 8501 for https by convention as some tooling will work automatically with this. (https://www.consul.io/docs/agent/options.html#https_port)"
  type        = number
  default     = -1
}

variable "grpc_port" {
  description = "The gRPC API, -1 to disable. Default -1 (disabled). We recommend using 8502 for grpc by convention as some tooling will work automatically with this. This is set to 8502 by default when the agent runs in -dev mode. Currently gRPC is only used to expose Envoy xDS API to Envoy proxies. (https://www.consul.io/docs/agent/options.html#dns_port)"
  type        = number
  default     = -1
}

variable "serf_lan_port" {
  description = "The Serf LAN port. Default 8301. TCP and UDP. (https://www.consul.io/docs/agent/options.html#serf_lan_port)"
  type        = number
  default     = 8301
}

variable "serf_wan_port" {
  description = "The Serf WAN port. Default 8302. Set to -1 to disable. Note: this will disable WAN federation which is not recommended. Various catalog and WAN related endpoints will return errors or empty results. TCP and UDP. (https://www.consul.io/docs/agent/options.html#serf_wan_port)"
  type        = number
  default     = 8302
}

variable "server_port" {
  description = "Server RPC address. Default 8300. TCP only. (https://www.consul.io/docs/agent/options.html#server_rpc_port)"
  type        = number
  default     = 8300
}

variable "sidecar_min_port" {
  description = "Inclusive minimum port number to use for automatically assigned sidecar service registrations. Default 21000. Set to 0 to disable automatic port assignment. (https://www.consul.io/docs/agent/options.html#sidecar_min_port)"
  type        = number
  default     = 21000
}

variable "sidecar_max_port" {
  description = "Inclusive maximum port number to use for automatically assigned sidecar service registrations. Default 21255. Set to 0 to disable automatic port assignment. (https://www.consul.io/docs/agent/options.html#sidecar_max_port)"
  type        = number
  default     = 21255
}

variable "connect" {
  description = "Controls whether Connect features are enabled on this agent. Should be enabled on all clients and servers in the cluster in order for Connect to function properly. Defaults to false. (https://www.consul.io/docs/agent/options.html#connect_enabled)"
  type        = bool
  default     = false
}

variable "enable_local_script_checks" {
  description = "Like enable_script_checks, but only enable them when they are defined in the local configuration files. Script checks defined in HTTP API registrations will still not be allowed. (https://www.consul.io/docs/agent/options.html#_enable_local_script_checks)"
  type        = bool
  default     = false
}

# variable "ca_file" {
#   description = "For future use"
#   type        = string
#   default     = null
# }

# variable "cert_file" {
#   description = "For future use"
#   type        = string
#   default     = null
# }

# variable "key_file" {
#   description = "For future use"
#   type        = string
#   default     = null
# }
