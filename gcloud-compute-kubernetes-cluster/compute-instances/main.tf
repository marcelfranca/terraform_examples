# K8s nodes
variable "nodes" {

  default = {
    0 = "kube-master"
    1 = "kube-worker1"
    2 = "kube-worker2"
  }
}

# Create node VMS
resource "google_compute_instance" "kube-node" {
  for_each = var.nodes
  name = each.value
  machine_type = "e2-standard-2" # 2 vCUPS, 8GB RAM

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  metadata = {
    ssh-keys = "demouser:${file("../id_rsa.pub")}"
  }

  network_interface {
    network = "test1"
    subnetwork = "dev-subnet-1"
    access_config {

    }
  }
}
