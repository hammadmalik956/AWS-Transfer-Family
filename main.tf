module "transfer" {
  source = "./modules/transfer"

  for_each               = { for k, v in var.server : k => v }
  identity_provider_type = each.value.identity_provider_type
  endpoint_type          = each.value.endpoint_type
  logging_role_arn       = module.transfer_custom_identity_provider[each.key].transfer_identity_provider_role_arn
  url                    = each.value.identity_provider_type == "API_GATEWAY" ? module.transfer_custom_identity_provider[each.key].transfer_identity_provider_url : null
  invocation_role        = each.value.identity_provider_type == "API_GATEWAY" ? module.transfer_custom_identity_provider[each.key].transfer_identity_provider_role_arn : null
}


module "transfer_custom_identity_provider" {
  source = "./modules/custom_identity_provider"

  for_each                  = { for k, v in var.server : k => v }
  api_gateway_rest_api_name = each.value.custom_identity_provider.api_gateway_rest_api_name
  api_gateway_stage_name    = each.value.custom_identity_provider.api_gateway_stage_name
  create_lambda_iam_role    = each.value.custom_identity_provider.create_lambda_iam_role
  create_transfer_iam_role  = each.value.custom_identity_provider.create_transfer_iam_role
  lambda_iam_role_name      = each.value.custom_identity_provider.lambda_iam_role_name
}


module "transfer-fam-custom" {
  source = "./modules/custom-module"
  for_each = { for k, v in var.users : k => v }

#   identity_provider_type = each.value.identity_provider_type
  transfer_server_id     = module.transfer[each.value.server_key].transfer_server_id
  user_name                  = each.value.user_name
  bucket_path                = each.value.bucket_path
  create_iam_role            = each.value.create_iam_role
  use_password               = each.value.use_password
  add_transfer_ssh_keys      = each.value.add_transfer_ssh_keys
  iam_role_policy_statements = each.value.iam_role_policy_statements
  create_transfer_user       = each.value.create_transfer_user
  public_key_list            = each.value.public_key_list
  transfer_ssh_key_bodys     = each.value.public_key_list
  identity_provider_type     = each.value.identity_provider_type
  

}



