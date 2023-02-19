variable "create_oauth_client" {
  default = false
}

variable "oauth_client_name" {
  default = ""
}

variable "github_oauth_token" {
  default   = ""
  sensitive = true
}

variable "workspaces" {
  default = {}
}

variable "aws_access_key" {
  default   = ""
  sensitive = true
}

variable "aws_secret_key" {
  default   = ""
  sensitive = true
}

variable "tfvars_file_path" {
  default = ""
}



