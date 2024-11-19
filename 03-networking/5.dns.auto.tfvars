# Examples
dns = [
  {
    name        = "example-com",
    parent_name = "cs-net-hub"
    domain      = "example.com."
    private_visibility_config_networks = [
      {
        vpc     = "hub"
        project = "cs-net-hub"
      },
    #   {
    #     vpc              = "vpc-demolz0002-pre"
    #     complete_project = "g-prj-demolz0002-cs-net-pre"
    #   },
    #   {
    #     vpc = "projects/g-prj-demolz0002-cs-net-pro/global/networks/vpc-demolz0002-pro"
    #   },
    ]
    recordsets = [
      {
        name    = ""
        type    = "NS"
        ttl     = 300
        records = ["ns.example.com."]
      },
      {
        name    = "localhost"
        type    = "A",
        ttl     = 300,
        records = ["127.0.0.1"]
      },
    ]
  },

]