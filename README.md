# terraform-cloud-workspace
Terraform Cloud Workspace를 만들고 셋팅합니다.

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|create_oauth_client|Oauth Client 생성 여부|bool|false|yes|
|oauth_client_name|Oauth Client 이름|string|""|yes|
|github_oauth_token|Github Personal Token|string|""|yes|
|workspaces|Workspace 설정|map|{}|yes|
|aws_access_key|AWS Access Key </br>주의) Public 공간에 공개하지 마세요.|string|""|yes|
|aws_secret_key|AWS Secret Key </br>주의) Public 공간에 공개하지 마세요.|string|""|yes|
|tfvars_file_path|한 개의 VCS Repo에서 tfvars가 여러개 있을 때 지정할 옵션. </br>[참고](https://github.com/psa-terraform/terraform-cloud-workspace)|string|""|yes|


## Workspace Map Example
```
workspaces = {
    network = {
        name = "dev-network"
        tags = ["dev", "network"]
        github_repo = "mzc/gitops-terraform"
        github_working_directory = "infra-network"
        github_branch = "main"
    }

    eks = {
        name = "dev-eks"
        tags = ["dev", "eks"]
        github_repo = "mzc/gitops-terraform"
        github_working_directory = "eks"
        github_branch = "main"        
    }
}
```
