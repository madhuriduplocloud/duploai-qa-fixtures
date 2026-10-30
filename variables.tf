variable "bucket_name" {
  description = "Globally-unique S3 bucket name. Keep it short-lived-test-looking (e.g. qa-tf-test-<run-id>) — this module is for throwaway test resources, not production buckets."
  type        = string
}

variable "region" {
  description = "AWS region to create the bucket in."
  type        = string
  default     = "us-west-2"
}

variable "versioning_enabled" {
  description = "Whether to enable bucket versioning — toggle this between test runs to exercise the Terraform Deployment resource's re-apply/update path."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Extra tags merged onto the bucket, e.g. { run = \"<RUN_ID>\" } so test buckets are identifiable/cleanup-able."
  type        = map(string)
  default     = {}
}

variable "object_expiration_days" {
  description = "Objects older than this many days are auto-deleted via a bucket lifecycle rule — these are throwaway test buckets, so nothing written to them should outlive a test run by much."
  type        = number
  default     = 7
}
