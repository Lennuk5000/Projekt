provider "proxmox" {
  pm_api_url      = "https://192.168.111.215:8006/"
  pm_user         = "root@pam"
  pm_password     = "lumesadu"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  count       = 3
  name        = "ubuntu-vm-${count.index + 1}"
  target_node = var.proxmox_host
  clone       = "ubuntu-cloud-template"

  os_type = "cloud-init"

  cores   = 2
  memory  = 2048
  sockets = 1

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  disk {
    slot    = 0
    type    = "scsi"
    storage = "local-lvm"
    size    = "20G"
  }

  ipconfig0 = "ip=192.168.111.${215 + count.index}/24,gw=192.168.111.1"

  sshkeys = var.ssh_key
}
