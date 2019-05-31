resource "null_resource" "dependencies" {
  triggers = {
    dependencies = var.dependencies == null ? join(",", []) : join(",", var.dependencies)
  }
}

resource "random_id" "gossip_encryption_key" {
  byte_length = 16
}

locals {
  gossip_encryption_key = var.gossip_encryption ? var.gossip_encryption_key == null ? random_id.gossip_encryption_key.b64_std : var.gossip_encryption_key : null
  server                = var.agent_type == "server" ? true : false
  consul_version        = var.consul_version == null ? "" : var.consul_version
  config_file = templatefile("${path.module}/templates/consul.json.tpl", {
    dc_name               = var.dc_name,
    server                = local.server
    ui                    = var.ui
    tls                   = var.tls
    data_dir              = var.data_dir
    connect               = var.connect
    bootstrap_expect      = var.bootstrap_expect,
    bind_address          = var.bind_address,
    gossip_encryption_key = local.gossip_encryption_key,
    retry_join            = jsonencode(var.retry_join),
    gossip_encryption     = var.gossip_encryption
    }
  )
}


# data "template_file" "consul_server_conf" {
#   template = file("${path.module}/templates/consul-server.json.tpl")

#   vars = {
#     dc_name          = var.dc_name
#     bootstrap_expect = var.bootstrap_expect
#     bind_address     = var.bind_address
#     encryption_key   = local.gossip_encryption_key
#     retry_join       = jsonencode(var.retry_join)
#   }
# }

resource "null_resource" "prereqs" {
  depends_on = ["null_resource.dependencies"]

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
  depends_on = ["null_resource.prereqs"]

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
  depends_on = ["null_resource.prereqs"]

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
  depends_on = ["null_resource.download_binary", "null_resource.upload_binary"]

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

resource "null_resource" "configure" {
  depends_on = ["null_resource.install"]

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
