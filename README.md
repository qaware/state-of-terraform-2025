# state-of-terraform-2025

TODO

## How to demo

### Basic setup

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
   The link will be displayed in the console output of `terraform apply` and will look something like [ `https://some-example-bucket-for-a-static-website-180524.s3-website.localhost.localstack.cloud:4566/`](https://some-example-bucket-for-a-static-website-180524.s3-website.localhost.localstack.cloud:4566/).
