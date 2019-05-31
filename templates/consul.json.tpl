{
  "datacenter": "${dc_name}",
  "data_dir": "${data_dir}",
  %{ if server }
  "server": true,
  "bootstrap_expect": ${bootstrap_expect},
  "performance": {
    "raft_multiplier": 1
  },
  %{ endif }
  %{ if gossip_encryption }"encrypt": "${gossip_encryption_key}",%{ endif }
  "ui": ${ui},
  "addresses": {
    %{ if tls }"https": "%{ if server }0.0.0.0%{ else }127.0.0.1%{ endif }",%{ endif }
    "http": "%{ if server }%{ if tls }127.0.0.1%{ else }0.0.0.0%{ endif }%{ else }127.0.0.1%{ endif }"
  },
  "ports": {
    %{ if tls }"https": 8501,%{ endif }
    "http": 8500
  },
  "bind_addr": "${bind_address}",
  "retry_join": ${retry_join},
  %{ if connect }
  "connect": {
    "enabled": true
  },
  %{ endif }
  "log_level": "info"
}
