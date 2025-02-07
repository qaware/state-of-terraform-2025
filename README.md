# state-of-terraform-2025

TODO

<!-- TOC -->
* [state-of-terraform-2025](#state-of-terraform-2025)
  * [How to demo](#how-to-demo)
    * [1. Basic setup](#1-basic-setup)
    * [2. Validations](#2-validations)
    * [3. Preconditions](#3-preconditions)
    * [4. Postconditions](#4-postconditions)
    * [5. "Unit Tests"](#5-unit-tests)
<!-- TOC -->

## How to demo

### 1. Basic setup

1. Start LocalStack Container

```bash
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack:4.1.0
```

2. Run Terraform init

```bash
terraform init
```

3. Run Terraform apply

```bash
terraform apply
```

4. Open the Static Website in Browser
   The link will be displayed in the console output of `terraform apply` and will look something like [ `https://some-example-bucket-for-a-static-website.s3-website.localhost.localstack.cloud:4566/`](https://some-example-bucket-for-a-static-website.s3-website.localhost.localstack.cloud:4566/).


### 2. Validations

1. Validation fails

```bash
terraform plan --var bucket_name="1.1.1.1"
```

2. Validation passes

```bash
terraform plan --var bucket_name="some-example-bucket-for-a-static-website"
```

### 3. Preconditions

This would fail the precondition:

```bash
terraform plan --var website_index_object_key="hello_world.html"
```

### 4. Postconditions

This would fail the postcondition:

```bash
terraform apply --var enable_versioning=false
```

This would satisfy the postcondition again:

```bash
terraform apply --var enable_versioning=true
```

Note, that this command does _not_ fail the postcondition:

```bash
terraform plan --var enable_versioning=false
```

### 5. "Unit Tests"

```bash
terraform test
```

Note, that this will create the actual resources and test on the live objects!

You can write tests which only test the plan output, by setting `command = plan` in the `run` block. The provided
example will not work on the plan output, however, because it uses the `etag` of the S3 object, which is not known
before the object is created.
