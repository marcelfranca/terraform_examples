resource "google_compute_instance" "instance" {
  name         = var.name
  machine_type = var.instance_type
  boot_disk {
    initialize_params {
      image = var.os_image_name
      size  = var.root_disk_size
    }
  }
  scratch_disk {
    interface = var.scratch_disk
  }
  network_interface {
    network    = var.vpc_name
    subnetwork = var.subnet_name
    network_ip = var.preferred_ip
    access_config {
      nat_ip = var.external_ip
    }
  }
  tags = var.tags
}
