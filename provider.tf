terraform {
  required_providers {
    gitlab = {
      source = "gitlabhq/gitlab"
      version = "3.1.0"
    }
  }
}

# Configure the GitLab Provider
provider "gitlab" {
    token = local.input.gitlab.token
    base_url = local.input.gitlab.url
    insecure = true
}
