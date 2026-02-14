output "vm_ip" {
  value = "${var.subnet}.${var.vm_ip_suffix}"
}
