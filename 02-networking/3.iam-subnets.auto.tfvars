## Examples (TO CHANGE)
iam_subnets = [
  {
    parent_name = "cs-net-pro"
    subnet_name = "pro-principal"
    member      = "serviceAccount:sa-demolz0002-sp-pro@g-prj-demolz0002-bootstrap.iam.gserviceaccount.com"
  },
  {
    parent_name = "cs-net-pre"
    subnet_name = "pre-principal"
    member      = "serviceAccount:sa-demolz0002-sp-pre@g-prj-demolz0002-bootstrap.iam.gserviceaccount.com"
  },
  {
    parent_name = "cs-net-dev"
    subnet_name = "dev-principal"
    member      = "serviceAccount:sa-demolz0002-sp-dev@g-prj-demolz0002-bootstrap.iam.gserviceaccount.com"
  }

]