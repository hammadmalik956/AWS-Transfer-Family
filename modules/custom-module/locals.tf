locals {
  validate_authentication_method = length([
    var.use_password,
    var.add_transfer_ssh_keys
  ]) == 1 ? "Valid configuration" : "Invalid configuration - only one of 'use_password' or 'add_transfer_ssh_keys' should be true."


  is_api_gateway_idp =  data.aws_transfer_server.server.identity_provider_type == "API_GATEWAY" ? true : false



  secret_content = merge(
    {
      Role          = aws_iam_role.this[0].arn,
      HomeDirectory = "/${var.bucket_path}"
    },
    var.use_password ? { Password = random_password.password[0].result } : {},
    var.add_transfer_ssh_keys && length(var.public_key_list) > 0 ? { PublicKey = element(var.public_key_list, 0) } : {}
  )

}