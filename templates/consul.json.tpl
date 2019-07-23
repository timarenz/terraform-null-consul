{
  "datacenter": "${datacenter}",
  %{ if primary_datacenter != "false" }"primary_datacenter": "${primary_datacenter}",%{ endif }
  "data_dir": "${data_dir}",
  %{ if agent_type == "server" }
  "server": true,
  %{ if bootstrap }"bootstrap_expect": ${bootstrap_expect},%{ endif }
  "performance": {
    "raft_multiplier": 1
  },
  %{ endif }
  "retry_join": ${retry_join},
  %{ if retry_join_wan != false }"retry_join_wan": ${retry_join_wan},%{ endif }
  %{ if encryption }"encrypt": "${encryption_key}",%{ endif }
  "ui": ${ui},
  %{ if serf_lan != "false" }"serf_lan": "${serf_lan}",%{ endif }
  %{ if serf_wan != "false" }"serf_wan": "${serf_wan}",%{ endif }
  %{ if translate_wan_addrs }"translate_wan_addrs": true,%{ endif }
  %{ if advertise_addr_wan != "false" }"advertise_addr_wan": "${advertise_addr_wan}",%{ endif }
  %{ if advertise_addr != "false" }"advertise_addr": "${advertise_addr}",%{ endif }
  "addresses": {
    "http": "%{ if agent_type == "server" }0.0.0.0%{ else }127.0.0.1%{ endif }"
  },
  "ports": {
    "dns": ${dns_port},
    "http": ${http_port},
    "https": ${https_port},
    "grpc": ${grpc_port},
    "serf_lan": ${serf_lan_port},
    "serf_wan": ${serf_wan_port},
    "server": ${server_port},
    "sidecar_min_port": ${sidecar_min_port},
    "sidecar_max_port": ${sidecar_max_port}
  },
  %{ if bind_addr != "false" }"bind_addr": "${bind_addr}",%{ endif }
  %{ if agent_type == "client" }%{ if enable_local_script_checks }"enable_local_script_checks": true,%{ endif }%{ endif }
  %{ if enable_central_service_config }"enable_central_service_config": true,%{ endif }
  %{ if connect }
  "connect": {
    "enabled": true
  },
  %{ endif }
  "log_level": "${log_level}"
}
