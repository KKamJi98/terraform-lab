resource "aws_s3_bucket" "terraform_state" {
  bucket              = "kkamji-terraform-state"
  object_lock_enabled = true
  lifecycle {
    # 삭제 방지
    prevent_destroy = true
  }

  tags = {
    Name        = "kkamji-terraform-state"
    Terraform   = "true"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# resource "aws_dynamodb_table" "terraform_locks" {
#   name         = "kkamji-terraform-state-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }