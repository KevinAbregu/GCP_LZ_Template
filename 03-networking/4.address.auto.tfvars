## Examples
address = [
  {
    parent_name  = "cs-net-hub"
    address_type = "EXTERNAL"
    names        = ["ip-nat-01"]
    global       = false
    addresses    = [""]

  },
  # Use Examples
  {
    parent_name = "cs-net-pro"
    subnet_name = "pro-principal"
    names       = ["test01", "test02", "cinco"]
    addresses   = ["", "", "10.0.2.5"]
  },

]
