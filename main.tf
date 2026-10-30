resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = merge(
    { source = "terraform-sample-modules/s3-bucket" },
    var.tags,
  )
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning_enabled ? "Enabled" : "Suspended"
  }
}

# Blocks all public access unconditionally — this module only ever creates throwaway test buckets, so there is
# no scenario where a test run should produce a publicly-reachable bucket.
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Auto-expires everything written to the bucket — QA test runs shouldn't need to remember to clean up
# objects they wrote (the bucket itself is still destroyed explicitly via `terraform destroy`, same as
# before; this only bounds what a *live* test bucket can accumulate between runs).
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expire-test-objects"
    status = "Enabled"

    filter {}

    expiration {
      days = var.object_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.object_expiration_days
    }
  }
}
