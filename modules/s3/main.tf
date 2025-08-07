terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.12.0"
}

resource "aws_s3_bucket" "this" {
  bucket        = local.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# STANDARD → STANDARD_IA → GLACIER → DEEP_ARCHIVE
# 高頻度 低頻度 長期保存 超長期保存
resource "aws_s3_bucket_lifecycle_configuration" "tiering" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "tiering"
    status = "Enabled"

    filter {}

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "DEEP_ARCHIVE"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    # 他のアカウントからアップロードされたオブジェクトも完全制御
    # 意図しないACL設定を防止
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket" "cf_logs" {
  bucket        = "${aws_s3_bucket.this.id}-cf-logs"
  force_destroy = true
  tags = {
    Project = aws_s3_bucket.this.id
    Purpose = "cloudfront-logs"
  }
}


resource "aws_s3_bucket_ownership_controls" "cf_logs" {
  bucket = aws_s3_bucket.cf_logs.id
  rule { object_ownership = "BucketOwnerPreferred" }
}

resource "aws_s3_bucket_acl" "cf_logs_acl" {
  bucket     = aws_s3_bucket.cf_logs.id
  acl        = "log-delivery-write"
  depends_on = [aws_s3_bucket_ownership_controls.cf_logs]
}

