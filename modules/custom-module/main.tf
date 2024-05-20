resource "aws_transfer_ssh_key" "ssh_key" {
  count = var.add_transfer_ssh_keys && length(var.public_key_list) > 0 && local.is_api_gateway_idp == "false" ? 1 : 0
  body      = element(var.public_key_list, count.index)
  server_id = var.transfer_server_id
  user_name = var.user_name

  depends_on = [ aws_transfer_user.this ]
}

resource "aws_transfer_user" "this" {
  count = var.identity_provider_type == "API_GATEWAY" ? 0 : 1
  role           = var.create_iam_role ? element(concat(aws_iam_role.this.*.arn, [""]), 0) : var.iam_role_arn
  server_id      = var.transfer_server_id
  user_name      = var.user_name
  tags           = var.tags
  home_directory = "/${var.bucket_path}"

  dynamic "home_directory_mappings" {
    for_each = var.home_directory_mappings

    content {
      entry  = home_directory_mappings.value["entry"]
      target = home_directory_mappings.value["target"]
    }
  }

  home_directory_type = var.home_directory_type
}

resource "random_password" "password" {
  count = var.use_password ? 1 : 0
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "aws_secretsmanager_secret" "user_secret" {
  name   = "SFTP/${var.user_name}"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.user_secret.id
  secret_string = jsonencode(local.secret_content)
  depends_on = [aws_iam_role_policy.inline_policy]
}

resource "aws_iam_role" "this" {
  count              = var.create_iam_role ? 1 : 0
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  name               = "Transfer-user-${var.user_name}"
  path               = "/"
}

resource "aws_iam_role_policy" "inline_policy" {
  count  = var.create_iam_role ? 1 : 0
  policy = data.aws_iam_policy_document.inline_policy[0].json
  role   = aws_iam_role.this[0].id

  depends_on = [aws_iam_role.this]
}
