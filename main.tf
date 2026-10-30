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

# QA fixture branch for DUPLOAI-3856: lifecycle configuration removed on purpose so that planning this
# branch against state applied from main produces a single "1 to destroy" diff for
# aws_s3_bucket_lifecycle_configuration.this, matching the ticket's repro precondition.
