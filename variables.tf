variable "dependency" {
  description = "Allows this module to depend and therefore wait on other resources"
  type        = string
  default     = null
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

variable "datacenter" {
  description = "This flag controls the datacenter in which the agent is running. If not provided, it defaults to 'dc1'. Consul has first-class support for multiple datacenters, but it relies on proper configuration. Nodes in the same datacenter should be on a single LAN. (https://www.consul.io/docs/agent/options.html#_datacenter)"
  type        = string
  default     = "dc1"
}

variable "primary_datacenter" {
  description = "This designates the datacenter which is authoritative for ACL information, intentions and is the root Certificate Authority for Connect. It must be provided to enable ACLs. All servers and datacenters must agree on the primary datacenter. (https://www.consul.io/docs/agent/options.html#primary_datacenter)"
  type        = string
  default     = null
}

variable "log_level" {
  description = "The level of logging to show after the Consul agent has started. This defaults to 'translate_wan_addrsinfo'translate_wan_addrs. The available log levels are 'translate_wan_addrstrace'translate_wan_addrs, 'translate_wan_addrsdebug'translate_wan_addrs, 'translate_wan_addrsinfo'translate_wan_addrs, 'translate_wan_addrswarn'translate_wan_addrs, and 'translate_wan_addrserr'translate_wan_addrs. (https://www.consul.io/docs/agent/options.html#_log_level)"
  type        = string
  default     = "info"
}

# variable "encryption" {
#   description = "Specifies the secret key to use for encryption of Consul network traffic. This key must be 16-bytes that are Base64-encoded. (https://www.consul.io/docs/agent/options.html#_encrypt)"
#   type        = bool
#   default     = false
# }

variable "encryption_key" {
  description = "Allows to specify an existing gossip key. If not specified one will be generated."
  type        = string
  default     = ""
}

variable "ui" {
  description = "Enables the built-in web UI server and the required HTTP routes. (https://www.consul.io/docs/agent/options.html#_ui)"
  type        = bool
  default     = true
}

# variable "bootstrap" {
#   description = "This flag is used to control if a server is in 'bootstrap' mode. (https://www.consul.io/docs/agent/options.html#_bootstrap_expect)"
#   type        = bool
#   default     = true
# }

variable "bootstrap_expect" {
  description = "This flag provides the number of expected servers in the datacenter. (https://www.consul.io/docs/agent/options.html#_bootstrap_expect)"
  type        = number
  default     = 1
}

variable "retry_join" {
  description = "Similar to -join but allows retrying a join if the first attempt fails. This is useful for cases where you know the address will eventually be available. The list can contain IPv4, IPv6, or DNS addresses. (https://www.consul.io/docs/agent/options.html#retry-join)"
  type        = list(string)
}

variable "retry_join_wan" {
  description = "Similar to retry-join but allows retrying a wan join if the first attempt fails. This is useful for cases where we know the address will become available eventually. (https://www.consul.io/docs/agent/options.html#_retry_join_wan)"
  type        = list(string)
  default     = null
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

variable "enable_central_service_config" {
  description = "When set, the Consul agent will look for any centralized service configurations that match a registering service instance. If it finds any, the agent will merge the centralized defaults with the service instance configuration. (https://www.consul.io/docs/agent/options.html#enable_central_service_config)"
  type        = string
  default     = false
}

variable "ca_file" {
  description = "This provides a PEM-encoded certificate authority. The certificate authority is used to check the authenticity of client and server connections with the appropriate verify_incoming or verify_outgoing flags. (https://www.consul.io/docs/agent/options.html#ca_file)"
  type        = string
  default     = null
}

variable "cert_file" {
  description = "This provides a PEM-encoded certificate. The certificate is provided to clients or servers to verify the agent's authenticity. It must be provided along with key_file. (https://www.consul.io/docs/agent/options.html#cert_file)"
  type        = string
  default     = null
}

variable "key_file" {
  description = "This provides a PEM-encoded private key. The key is used with the certificate to verify the agent's authenticity. This must be provided along with cert_file. (https://www.consul.io/docs/agent/options.html#key_file)"
  type        = string
  default     = null
}

variable "verify_incoming" {
  description = " If set to true, Consul requires that all incoming connections make use of TLS and that the client provides a certificate signed by a Certificate Authority from the ca_file or ca_path. This applies to both server RPC and to the HTTPS API. (https://www.consul.io/docs/agent/options.html#verify_incoming)"
  type        = string
  default     = false
}

variable "verify_incoming_rpc" {
  description = "If set to true, Consul requires that all incoming RPC connections make use of TLS and that the client provides a certificate signed by a Certificate Authority from the ca_file or ca_path. (https://www.consul.io/docs/agent/options.html#verify_incoming_rpc)"
  type        = string
  default     = false
}

variable "verify_incoming_https" {
  description = "If set to true, Consul requires that all incoming HTTPS connections make use of TLS and that the client provides a certificate signed by a Certificate Authority from the ca_file or ca_path. (https://www.consul.io/docs/agent/options.html#verify_incoming_https)"
  type        = string
  default     = false
}

variable "verify_outgoing" {
  description = "If set to true, Consul requires that all outgoing connections from this agent make use of TLS and that the server provides a certificate that is signed by a Certificate Authority from the ca_file or ca_path. (https://www.consul.io/docs/agent/options.html#verify_outgoing)"
  type        = string
  default     = false
}

variable "verify_server_hostname" {
  description = "If set to true, Consul verifies for all outgoing TLS connections that the TLS certificate presented by the servers matches \"server.<datacenter>.<domain>\"  hostname. (https://www.consul.io/docs/agent/options.html#verify_server_hostname)"
  type        = string
  default     = false
}

variable "auto_encrypt" {
  description = "This option enables auto_encrypt on the servers and allows them to automatically distribute certificates from the Connect CA to the clients. If enabled, the server can accept incoming connections from both the built-in CA and the Connect CA, as well as their certificates. (https://www.consul.io/docs/agent/options.html#auto_encrypt)"
  type        = string
  default     = false
}

variable "acl" {
  description = "Enables ACLs. (https://www.consul.io/docs/agent/options.html#acl_enabled)"
  type        = bool
  default     = false
}

variable "default_policy" {
  description = "Either \"allow\" or \"deny\"; defaults to \"allow\" but this will be changed in a future major release. The default policy controls the behavior of a token when there is no matching rule. (https://www.consul.io/docs/agent/options.html#acl_default_policy)"
  type        = string
  default     = "deny"
}

variable "enable_token_persistence" {
  description = "Either true or false. When true tokens set using the API will be persisted to disk and reloaded when an agent restarts. (https://www.consul.io/docs/agent/options.html#acl_enable_token_persistence)"
  type        = bool
  default     = true
}

variable "node_meta" {
  description = "Available in Consul 0.7.3 and later, This object allows associating arbitrary metadata key/value pairs with the local node, which can then be used for filtering results from certain catalog endpoints. (https://www.consul.io/docs/agent/options.html#node_meta)"
  type        = map
  default     = null
}

variable "autopilot" {
  description = "Added in Consul 0.8, this object allows a number of sub-keys to be set which can configure operator-friendly settings for Consul servers. When these keys are provided as configuration, they will only be respected on bootstrapping. If they are not provided, the defaults will be used. (https://www.consul.io/docs/agent/options.html#autopilot)"
  type        = map
  default     = null
  # default = {
  #   redundancy_zone_tag = "someredundancytag"
  #   upgrade_version_tag "someversiontag"
  # }
}

variable "segment" {
  description = " (Enterprise-only) This flag is used to set the name of the network segment the agent belongs to. An agent can only join and communicate with other agents within its network segment. By default, this is an empty string, which is the default network segment. (https://www.consul.io/docs/agent/options.html#_segment)"
  type        = string
  default     = null
}

variable "segments" {
  description = "(Enterprise-only) This is a list of nested objects that allows setting the bind/advertise information for network segments. This can only be set on servers. (https://www.consul.io/docs/agent/options.html#segments)"
  type        = list
  default     = null
  # default = [
  #   {
  #     "name": "alpha",
  #     "bind": "{{GetPrivateIP}}",
  #     "advertise": "{{GetPrivateIP}}",
  #     "port": 8303
  #   },
  #   {
  #     "name": "beta",
  #     "bind": "{{GetPrivateIP}}",
  #     "advertise": "{{GetPrivateIP}}",
  #     "port": 8304
  #   }
  # ]
}

variable "agent_token" {
  description = "Used for clients and servers to perform internal operations. If this isn't specified, then the default will be used. (https://www.consul.io/docs/agent/options#acl_tokens_agent)"
  type        = string
  default     = ""
}

variable "master_token" {
  description = "nly used for servers in the primary_datacenter. This token will be created with management-level permissions if it does not exist. It allows operators to bootstrap the ACL system with a token Secret ID that is well-known. (https://www.consul.io/docs/agent/options#acl_tokens_master)"
  type        = string
  default     = ""
}

variable "enable_mesh_gateway_wan_federation" {
  description = "Controls whether cross-datacenter federation traffic between servers is funneled through mesh gateways. Defaults to false. This was added in Consul 1.8.0. (https://www.consul.io/docs/agent/options#connect_enable_mesh_gateway_wan_federation)"
  type        = bool
  default     = false
}

variable "audit_log" {
  description = "Controls whether Consul logs out each time a user performs an operation. ACLs must be enabled to use this feature. Defaults to false. (https://www.consul.io/docs/agent/options.html#enabled-1)"
  type        = bool
  default     = false
}

variable "audit_log_rotate_duration" {
  description = "Specifies the interval by which the system rotates to a new log file. At least one of rotate_duration or rotate_bytes must be configured to enable audit logging. (https://www.consul.io/docs/agent/options.html#rotate_duration)"
  type        = string
  default     = "24h"
}

variable "audit_log_rotate_max_files" {
  description = "Defines the limit that Consul should follow before it deletes old log files. (https://www.consul.io/docs/agent/options.html#rotate_max_files)"
  type        = number
  default     = 15
}

variable "audit_log_rotate_bytes" {
  description = "Specifies how large an individual log file can grow before Consul rotates to a new file. At least one of rotate_bytes or rotate_duration must be configured to enable audit logging. (https://www.consul.io/docs/agent/options.html#rotate_bytes)"
  type        = number
  default     = 25165824
}
