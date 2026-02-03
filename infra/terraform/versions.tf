terraform {
  required_version = ">= 1.6.0"

  # State Management (produção): recomenda-se usar um backend remoto em S3 com
  # DynamoDB para lock de estado e consistência em times.
  # Exemplo (não habilitado neste blueprint):
  # backend "s3" {
  #   bucket         = "<terraform-state-bucket>"
  #   key            = "aws-data-lakehouse-blueprint/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "<terraform-lock-table>"
  #   encrypt        = true
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5"
    }
  }
}
