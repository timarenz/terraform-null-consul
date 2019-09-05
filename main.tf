resource "null_resource" "dependencies" {
  triggers = {
    dependencies = var.dependencies == null ? join(",", []) : join(",", var.dependencies)
  }
}

resource "random_id" "encryption_key" {
  byte_length = 16
}

locals {
  encryption_key = var.encryption ? var.encryption_key == null ? random_id.encryption_key.b64_std : var.encryption_key : null
  consul_version = var.consul_version == null ? "" : var.consul_version
  config_file = templatefile("${path.module}/templates/consul.json.tpl", {
    datacenter                    = var.datacenter
    primary_datacenter            = var.primary_datacenter == null ? false : var.primary_datacenter
    agent_type                    = var.agent_type
    ui                            = var.ui
    data_dir                      = var.data_dir
    connect                       = var.connect
    bootstrap                     = var.bootstrap
    bootstrap_expect              = var.bootstrap_expect
    bind_addr                     = var.bind_addr == null ? false : var.bind_addr
    encryption_key                = local.encryption_key
    retry_join                    = jsonencode(var.retry_join)
    retry_join_wan                = var.retry_join_wan == null ? false : jsonencode(var.retry_join_wan)
    encryption                    = var.encryption
    enable_local_script_checks    = var.enable_local_script_checks
    enable_central_service_config = var.enable_central_service_config
    serf_lan                      = var.serf_lan == null ? false : var.serf_lan
    serf_wan                      = var.serf_wan == null ? false : var.serf_wan
    advertise_addr_wan            = var.advertise_addr_wan == null ? false : var.advertise_addr_wan
    advertise_addr                = var.advertise_addr == null ? false : var.advertise_addr
    translate_wan_addrs           = var.translate_wan_addrs
    log_level                     = var.log_level
    dns_port                      = var.dns_port
    http_port                     = var.http_port
    https_port                    = var.https_port
    grpc_port                     = var.grpc_port
    serf_lan_port                 = var.serf_lan_port
    serf_wan_port                 = var.serf_wan_port
    server_port                   = var.server_port
    sidecar_min_port              = var.sidecar_min_port
    sidecar_max_port              = var.sidecar_max_port
    ca_file                       = var.ca_file == null ? false : var.ca_file
    cert_file                     = var.cert_file == null ? false : var.cert_file
    key_file                      = var.key_file == null ? false : var.key_file
    auto_encrypt                  = var.auto_encrypt
    verify_incoming               = var.verify_incoming
    verify_incoming_rpc           = var.verify_incoming_rpc
    verify_incoming_https         = var.verify_incoming_https
    verify_outgoing               = var.verify_outgoing
    verify_server_hostname        = var.verify_server_hostname
    }
  )
}

# data "template_file" "consul_server_conf" {
#   template = file("${path.module}/templates/consul-server.json.tpl")

#   vars = {
#     dc_name          = var.dc_name
#     bootstrap_expect = var.bootstrap_expect
#     bind_address     = var.bind_address
#     encryption_key   = local.encryption_key
#     retry_join       = jsonencode(var.retry_join)
#   }
# }

resource "null_resource" "prereqs" {
  depends_on = [null_resource.dependencies]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/install-prereqs.sh"
  }
}

resource "null_resource" "download_binary" {
  count      = var.consul_binary == null ? 1 : 0
  depends_on = [null_resource.prereqs]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = "${path.module}/scripts/download-consul.sh"
    destination = "download-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x download-consul.sh",
      "CONSUL_VERSION=${local.consul_version} ./download-consul.sh"
    ]
  }
}

resource "null_resource" "upload_binary" {
  count      = var.consul_binary == null ? 0 : 1
  depends_on = [null_resource.prereqs]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.consul_binary
    destination = "consul"
  }
}

resource "null_resource" "install" {
  depends_on = [null_resource.download_binary, null_resource.upload_binary]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/install-consul.sh"
  }
}

resource "null_resource" "upload_ca_file" {
  count      = var.ca_file == null ? 0 : 1
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.ca_file
    destination = "ca.pem"
  }
}

resource "null_resource" "upload_key_file" {
  count      = var.key_file == null ? 0 : 1
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.key_file
    destination = "server.key"
  }
}

resource "null_resource" "upload_cert_file" {
  count      = var.cert_file == null ? 0 : 1
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.cert_file
    destination = "server.pem"
  }
}

resource "null_resource" "upload_cli_key_file" {
  count      = var.cli_key_file == null ? 0 : 1
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.cli_key_file
    destination = "cli.key"
  }
}

resource "null_resource" "upload_cli_cert_file" {
  count      = var.cli_cert_file == null ? 0 : 1
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    source      = var.cli_cert_file
    destination = "cli.pem"
  }
}

resource "null_resource" "configure" {
  depends_on = [null_resource.install, null_resource.upload_ca_file, null_resource.upload_key_file, null_resource.upload_cert_file]
  triggers = {
    template = local.config_file
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    content     = local.config_file
    destination = "consul.json"
  }

  provisioner "remote-exec" {
    script = "${path.module}/scripts/configure-consul.sh"
  }
}
