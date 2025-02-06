variable "bucket_name" {
  description = "The name of the S3 bucket to create for the static website."
  type        = string
  default     = "some-example-bucket-for-a-static-website"

  validation {
    condition = (
      # Check length is between 3 and 63.
      length(var.bucket_name) >= 3 &&
      length(var.bucket_name) <= 63 &&

      # Ensure the bucket name is all lowercase.
      var.bucket_name == lower(var.bucket_name) &&

      # Ensure the bucket name matches allowed characters and starts/ends with a letter or digit.
      can(regex("^([a-z0-9])([a-z0-9.-]*)([a-z0-9])$", var.bucket_name)) &&

      # Disallow consecutive periods.
      !strcontains(var.bucket_name, "..") &&

      # Disallow names that look like an IP address.
      !can(regex("^(\\d+\\.){3}\\d+$", var.bucket_name))
    )
    error_message = "Invalid bucket name. It must be 3–63 characters long, all lowercase, start and end with a letter or digit, contain only letters, numbers, hyphens, and periods, not contain consecutive periods, and not be an IP address."
  }
}

variable "website_index_object_key" {
  description = "The key of the object to upload to the S3 bucket as the index document."
  type        = string
  default     = "index.html"
}