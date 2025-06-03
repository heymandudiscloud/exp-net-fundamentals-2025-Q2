## VPC Settings

These are the VPC Settings we observed Tim setup for our cloud environment in AWS:

- VPC IPv4 CIDR Block: 10.200.123.0/24
- IPv6 CIDR Block: No
- Number of AZs: 1
- Number of public subnets: 1
- Number of private subnets: 1
- NAT Gateways: None
- VPC Endpoints: None
- DNS Options: Enable DNS Hostnames
- DNS options: Enable DNS Resolution

## Generated and Review CFN Template

Watching the instructor's videos, I noted the VPC Settings, provided this to an LLM to produce the CFN to automate the provision of the VPC infrastructure.

- I had to ask the LLM to refactor the parameters so that it would not hardcode values and the template is more reusable.

## Generated Deploy Script

Using ChatGPT generated a bash script `bin/deploy`

I changed the shebang to work for all OS platforms

## Visualisation in Infrastructure Composer

I thought maybe we could visualise our VPC via Infrastructure Composer but it's not the best representation.

![](assets\aws_infr_composer.png)

## Installing AWS CLI

In order to deploy via the AWS CLI, we need to install it.

We follow the install instructions:
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

## Deployed Resource to AWS

This is a resource map of the VPC deployed with CFN.

![](assets\aws_vpc_resource_map.png)