# terraform-aws
Terraform Template for any Cluster on AWS

With given "name" as your project name,
 * creates new key for further communication
 * creates a brand new VPC
 * creates multiple subnets in different AZs
 * configures your VPC with route table and its associations, dhcp options, internet gateway, vpn gateway
 * creates security groups and its rules
 * creates a new iam role and instance profile for this project
 * creates a launch configuration and auto scaling group - cloud init can be injectable


All parameters are configurable but has predefined sane defaults.


first run:

```terraform get```

to fix the dependeny management for terraform

then do:

``` terraform apply ```


