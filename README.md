# state-of-terraform-2025

TODO

<!-- TOC -->
* [state-of-terraform-2025](#state-of-terraform-2025)
  * [How to demo](#how-to-demo)
    * [1. Basic setup](#1-basic-setup)
    * [2. Validations](#2-validations)
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

