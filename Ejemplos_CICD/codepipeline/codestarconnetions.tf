resource "aws_codestarconnections_connection" "example" {
  name          = "github_connection"
  provider_type = "GitHub"
}

