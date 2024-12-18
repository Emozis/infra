provider "aws" {
  region = "ap-northeast-2"
}

locals {
  env_vars = { for tuple in regexall("(.*)=(.*)", file("${path.module}/.env")) : tuple[0] => tuple[1] }
}