# aws-ec2-connection-options-demo

This repository accompanies a stream that was recorded and
[published on YouTube](https://www.youtube.com/watch?v=I8sd07_2Z6M&t=1s).

## Purpose

The purpose of this repository is to document various different ways that you
can connect to an EC2 instance, each with differing levels of security and
complexity.

## Demo infrastructure

Most infrastructure will be provisioned by Terraform. The exceptions are the EC2
key pair used for SSH, and the EC2 Instance Connect Endpoint.

Before running Terraform, you'll need to create a key pair in the same region
that you're deploying this into. By default, this is `eu-west-1`. I'd suggest
`${var.demo_application_name}` as the name for the key pair. This will save you
having to override Terraform variables when applying the configuration.

A simple set of commands will deploy the demo into your account with sensible
defaults.

```sh
terraform init
terraform apply
```

Once this has completed successfully, you'll need to manually create an EC2
Instance Connect Endpoint. You can do this in the console, or via the CLI. Just
make sure it is created in the private subnet that Terraform created for us, and
the security group with name ending `-private-ec2-for-eic-sg` is attached to it.
