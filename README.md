# state-of-terraform-2025

This repo is complementary to the talk "State of terraform 2025".

<!-- TOC -->
* [state-of-terraform-2025](#state-of-terraform-2025)
  * [How to demo](#how-to-demo)
    * [1. Basic setup](#1-basic-setup)
    * [2. Validations](#2-validations)
    * [3. Preconditions](#3-preconditions)
    * [4. Postconditions](#4-postconditions)
    * [5. "Unit Tests" / "Integration Tests"](#5-unit-tests--integration-tests)
    * [6. Checks ("End-to-End Tests")](#6-checks-end-to-end-tests)
<!-- TOC -->

## How to demo

### 1. Basic setup

1. Start LocalStack Container

```bash
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack:4.1.0
```

2. Run Terraform init

```bash
tofu init
terraform init
```

3. Run Terraform apply

```bash
tofu apply
terraform apply
```

4. Open the Static Website in Browser
   The link will be displayed in the console output of `terraform apply` and will look something like
   [`https://some-example-bucket-for-a-static-website.s3-website.localhost.localstack.cloud:4566/`](https://some-example-bucket-for-a-static-website.s3-website.localhost.localstack.cloud:4566/).

5. List bucket created in localstack:
   `awslocal s3api list-buckets`.

### 2. Validations

1. Validation fails

```bash
tofu plan --var bucket_name="1.1.1.1"
terraform plan --var bucket_name="1.1.1.1"
```

2. Validation passes

```bash
tofu plan --var bucket_name="some-example-bucket-for-a-static-website"
terraform plan --var bucket_name="some-example-bucket-for-a-static-website"
```

### 3. Preconditions

This would fail the precondition:

```bash
tofu plan --var website_index_object_key="hello_world.html"
terraform plan --var website_index_object_key="hello_world.html"
```

### 4. Postconditions

This would fail the postcondition:

```bash
tofu apply --var enable_versioning=false
terraform apply --var enable_versioning=false
```

This would satisfy the postcondition again:

```bash
tofu apply --var enable_versioning=true
terraform apply --var enable_versioning=true
```

Note, that this command does _not_ fail the postcondition:

```bash
tofu plan --var enable_versioning=false
terraform plan --var enable_versioning=false
```

### 5. "Unit Tests" / "Integration Tests"

```bash
tofu test
terraform test
```

### 6. Checks ("End-to-End Tests")

Rerun `terraform apply` or `tofu apply` and watch the output. You can also change something in the assertion in
[`check.tf`](./check.tf)
to see how the check fails.
