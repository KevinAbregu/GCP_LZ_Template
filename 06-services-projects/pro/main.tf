resource "google_compute_instance" "default" {
  name         = "my-instance"
  machine_type = "n2-standard-2"
  zone         = "europe-west1-b"
  tags = ["foo", "bar"]
  project = "g-prj-kevinlz02-pro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        my_label = "value"
      }
    }
  }
  network_interface {
    subnetwork = "projects/g-prj-kevinlz02-cs-net-pro/regions/europe-west1/subnetworks/snet-kevinlz02-pro-principal"
    access_config {
    }
  }
  metadata = {
    foo = "bar"
  }
  metadata_startup_script = "apt install nginx -y"

}