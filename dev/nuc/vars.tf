variable "libvirt_uri" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "vm_vcpu" {
  type = number
}

variable "vm_memory" {
  type = number
}

variable "vm_disk_size" {
  type = number
}

variable "volume_pool" {
  type = string
}

variable "subnet" {
  type = string
}

variable "vm_ip_suffix" {
  type = number
}

variable "os_image_source" {
  type = string
}

variable "ssh_public_key" {
  type = string
}
