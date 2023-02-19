terraform {
  required_version = ">= 1.2.0, < 2.0.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.42.0"
    }
  }
}

provider "tfe" {
  organization = "MZC-ORG"
}

# organization
data "tfe_organization" "org" {
  name = "MZC-ORG"
}

# Create github oauth client 
resource "tfe_oauth_client" "github" {
  count            = var.create_oauth_client ? 1 : 0
  name             = var.oauth_client_name
  organization     = data.tfe_organization.org.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token
  service_provider = "github"
}

# Use github oauth client 
data "tfe_oauth_client" "github" {
  count            = var.create_oauth_client ? 0 : 1
  organization     = data.tfe_organization.org.name
  name             = var.oauth_client_name
  service_provider = "github"
}

# workspace
resource "tfe_workspace" "workspace" {
  for_each     = var.workspaces
  name         = each.value.name
  organization = data.tfe_organization.org.name
  tag_names    = each.value.tags

  vcs_repo {
    identifier     = each.value.github_repo
    branch         = each.value.github_branch
    oauth_token_id = var.create_oauth_client ? tfe_oauth_client.github.0.oauth_token_id : data.tfe_oauth_client.github.0.oauth_token_id
  }

  working_directory = each.value.github_working_directory
}

# workspace variable setting
resource "tfe_variable" "variable_aws_access_key" {
  for_each     = var.workspaces
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key
  category     = "env"
  workspace_id = tfe_workspace.workspace[each.key].id
  sensitive    = true
}

resource "tfe_variable" "variable_aws_secret_key" {
  for_each     = var.workspaces
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_key
  category     = "env"
  workspace_id = tfe_workspace.workspace[each.key].id
  sensitive    = true
}

resource "tfe_variable" "variable_var_file" {
  for_each     = var.workspaces
  key          = "TF_CLI_ARGS_plan"
  value        = "-var-file=${var.tfvars_file_path}"
  category     = "env"
  workspace_id = tfe_workspace.workspace[each.key].id
}
