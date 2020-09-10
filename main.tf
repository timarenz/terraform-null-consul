# resource "random_id" "encryption_key" {
#   count       = var.encryption_key == null ? 1 : 0
#   byte_length = 32
# }

resource "random_id" "random" {
  byte_length = 3
}

locals {
  # encryption_key = var.encryption ? var.encryption_key == null ? random_id.encryption_key[0].b64_std : var.encryption_key : null
  consul_version = var.consul_version == null ? "" : var.consul_version
  config_file = templatefile("${path.module}/templates/consul.hcl.tpl", {
    datacenter         = var.datacenter
    primary_datacenter = var.primary_datacenter == null ? false : var.primary_datacenter
    agent_type         = var.agent_type
    ui                 = var.ui
    data_dir           = var.data_dir
    connect            = var.connect
    bootstrap          = var.bootstrap
    bootstrap_expect   = var.bootstrap_expect
    bind_addr          = var.bind_addr == null ? false : var.bind_addr
    encryption_key     = var.encryption_key
    retry_join         = jsonencode(var.retry_join)
    retry_join_wan     = var.retry_join_wan == null ? false : jsonencode(var.retry_join_wan)
    # encryption                    = var.encryption
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
    acl                           = var.acl
    default_policy                = var.default_policy
    enable_token_persistence      = var.enable_token_persistence
    node_meta                     = var.node_meta == null ? {} : var.node_meta
    autopilot                     = var.autopilot == null ? {} : var.autopilot
    segments                      = var.segments == null ? [] : var.segments
    segment                       = var.segment == null ? false : var.segment
    }
  )
  binary_trigger     = element(coalescelist(null_resource.download_binary[*].id, null_resource.upload_binary[*].id, [0]), 0)
  file_placeholder   = "PLACEHOLDER FILE - NOT USED\n"
  random_temp_folder = "/tmp/consul-${random_id.random.dec}"
}

resource "null_resource" "prereqs" {
  depends_on = [null_resource.temp_folder]
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
  triggers = {
    version = var.consul_version
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/download-consul.sh"
    destination = "${local.random_temp_folder}/download-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${local.random_temp_folder}",
      "chmod +x download-consul.sh",
      "CONSUL_VERSION=${local.consul_version} ./download-consul.sh"
    ]
  }
}

resource "null_resource" "upload_binary" {
  count      = var.consul_binary == null ? 0 : 1
  depends_on = [null_resource.prereqs]
  triggers = {
    binary = var.consul_binary
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    source      = var.consul_binary
    destination = "${local.random_temp_folder}/consul"
  }
}

resource "null_resource" "install" {
  depends_on = [null_resource.upload_binary, null_resource.download_binary]
  triggers = {
    binary = local.binary_trigger
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install-consul.sh"
    destination = "${local.random_temp_folder}/install-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${local.random_temp_folder}",
      "chmod +x install-consul.sh",
      "CONSUL_DATA_DIR=${var.data_dir} ./install-consul.sh"
    ]
  }
}

resource "null_resource" "install_service" {
  depends_on = [null_resource.install]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/install-consul-service.sh"
    destination = "${local.random_temp_folder}/install-consul-service.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${local.random_temp_folder}",
      "chmod +x install-consul-service.sh",
      "CONSUL_DATA_DIR=${var.data_dir} ./install-consul-service.sh"
    ]
  }

  # provisioner "remote-exec" {
  #   when = "destroy"
  #   inline = [
  #     "sudo systemctl stop consul.service",
  #     "sudo userdel consul"
  #   ]
  # }
}

resource "null_resource" "upload_ca_file" {
  # count      = var.ca_file == null ? 0 : 1
  depends_on = [null_resource.install_service]

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    content     = var.ca_file == null ? local.file_placeholder : var.ca_file
    destination = "${local.random_temp_folder}/ca.pem"
  }
}

resource "null_resource" "upload_key_file" {
  # count      = var.key_file == null ? 0 : 1
  depends_on = [null_resource.install_service]
  triggers = {
    key_file = var.key_file
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    content     = var.key_file == null ? local.file_placeholder : var.key_file
    destination = "${local.random_temp_folder}/server.key"
  }
}

resource "null_resource" "upload_cert_file" {
  # count      = var.cert_file == null ? 0 : 1
  depends_on = [null_resource.install_service]
  triggers = {
    cert_file = var.cert_file
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.random_temp_folder}"
    ]
  }

  provisioner "file" {
    content     = var.cert_file == null ? local.file_placeholder : var.cert_file
    destination = "${local.random_temp_folder}/server.pem"
  }
}

resource "null_resource" "configure" {
  depends_on = [
    null_resource.temp_folder,
    null_resource.prereqs,
    null_resource.download_binary,
    null_resource.upload_binary,
    null_resource.install_service,
    null_resource.upload_ca_file,
    null_resource.upload_key_file,
    null_resource.upload_cert_file,
  ]

  triggers = {
    template  = local.config_file
    install   = null_resource.install.id
    cert_file = var.cert_file
    key_file  = var.key_file
    ca_file   = var.ca_file
  }

  connection {
    type        = "ssh"
    host        = var.host
    user        = var.username
    private_key = var.ssh_private_key
  }

  provisioner "file" {
    content     = local.config_file
    destination = "${local.random_temp_folder}/consul.hcl"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/configure-consul.sh"
    destination = "${local.random_temp_folder}/configure-consul.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cd ${local.random_temp_folder}",
      "chmod +x configure-consul.sh",
      "./configure-consul.sh",
      "rm -rf ${local.random_temp_folder}"
    ]
  }

  # provisioner "remote-exec" {
  #   when   = destroy
  #   script = "${path.module}/scripts/disable-consul.sh"
  # }
}

resource "null_resource" "complete" {
  depends_on = [
    null_resource.temp_folder,
    null_resource.prereqs,
    null_resource.download_binary,
    null_resource.upload_binary,
    null_resource.install,
    null_resource.install_service,
    null_resource.upload_ca_file,
    null_resource.upload_key_file,
    null_resource.upload_cert_file,
    null_resource.configure
  ]

  triggers = {
    prereqs         = null_resource.prereqs.id
    binary          = local.binary_trigger,
    install         = null_resource.install.id,
    install_service = null_resource.install_service.id,
    configure       = null_resource.configure.id
  }
}
