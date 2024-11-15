# Example

instance_template = [
  #   {
  #     parent_name = "cs-net-hub"
  #     name_template = "instance-template-dns-server"
  #     name_prefix =  "instance-template-dns-server"
  #     network_ip         = "10.150.0.26"
  #     disk_size_gb = "10"
  #     disk_type = "pd-balanced"
  #     enable_shielded_vm = false
  #     network = "vpc-sws-hub"
  #     region = "europe-west4"
  #     service_account = {  # (Required)
  #       email  = ""
  #       scopes = []
  #     }
  #     machine_type = "e2-micro"
  #     source_image = "image-dns-server"
  #     source_image_project = "g-prj-sws-cs-net-hub"
  #     subnetwork  =  "snet-sws-hub-principal"
  #     subnetwork_project  =  "g-prj-sws-cs-net-hub"
  # }
]
