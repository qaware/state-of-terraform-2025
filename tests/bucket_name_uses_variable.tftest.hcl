run "bucket_name_uses_variable" {
  command = plan

  variables {
    bucket_name = "test-bucket"
  }

  # Check that the bucket name is correct
  assert {
    condition     = aws_s3_bucket.static_site_bucket.bucket == "test-bucket"
    error_message = "Bucket name does not match input variable."
  }

  # Of course, if we only plan to create the bucket, it will not have a website endpoint yet and our check will fail, 
  # so we need to tell terraform that we expect this failure.
  expect_failures = [check.website_status_code]
}