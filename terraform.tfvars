region      = "us-west-2"
environment = "stage"
identifier  = "bidfta"
project     = "transfer-family"

server = {
  server-1 = {
    identity_provider_type = "API_GATEWAY"
    endpoint_type          = "PUBLIC"
    custom_identity_provider = {
      api_gateway_rest_api_name = "eurustech"
      api_gateway_stage_name    = "prod"
      create_lambda_iam_role    = true
      create_transfer_iam_role  = true
      lambda_iam_role_name      = "LambdaRoleTF"
    }
  }
}

users = {
  user-1 = {
    identity_provider_type = "API_GATEWAY"
    server_key                 = "server-1"
    bucket_path              = "transfer-fam-bucket"
    user_name                  = "bilalali2"
    create_iam_role            = true
    create_transfer_user       = true
    use_password               = true
    add_transfer_ssh_keys      = false
    public_key_list            = []
    iam_role_policy_statements = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*"
        }
    ]
    }
    EOF 
  }
  user-2 = {
    identity_provider_type = "API_GATEWAY"
    server_key                 = "server-1"
    bucket_path                = "transfer-fam-bucket"
    user_name                  = "bilalali0"
    create_iam_role            = true
    create_transfer_user       = true
    use_password               = true
    add_transfer_ssh_keys      = false
    public_key_list            = []
    iam_role_policy_statements = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Action": "s3:*",
        "Resource": "*"
        }
    ]
    }
    EOF 
  }
}





