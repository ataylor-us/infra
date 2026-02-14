resource "libvirt_volume" "base" {
  name   = "${var.vm_name}-base.qcow2"
  pool   = var.volume_pool
  source = var.os_image_source
  format = "qcow2"
}

resource "libvirt_volume" "disk" {
  name           = "${var.vm_name}.qcow2"
  pool           = var.volume_pool
  base_volume_id = libvirt_volume.base.id
  size           = var.vm_disk_size
  format         = "qcow2"
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${var.vm_name}-cloudinit.iso"
  pool = var.volume_pool

  user_data = templatefile("${path.module}/user-data.tpl", {
    hostname       = var.vm_name
    ssh_public_key = var.ssh_public_key
  })

  meta_data = templatefile("${path.module}/meta-data.tpl", {
    instance_id    = var.vm_name
    local_hostname = var.vm_name
  })

  network_config = templatefile("${path.module}/network-config.tpl", {
    ip_address = "${var.subnet}.${var.vm_ip_suffix}"
    gateway    = "${var.subnet}.1"
  })
}

resource "libvirt_domain" "nuc_staging" {
  name       = var.vm_name
  memory     = var.vm_memory
  vcpu       = var.vm_vcpu
  qemu_agent = false

  network_interface {
    network_name   = "default"
    wait_for_lease = false
  }

  disk {
    volume_id = libvirt_volume.disk.id
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit.id

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "vnc"
    listen_type = "address"
    autoport    = true
  }
}
