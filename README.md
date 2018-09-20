#devops-project

Given the use case of a static web application, I'm choosing to host the content from S3. I chose S3 because it is free-tier, serverless (which means less security surface area), and fast. If there isn't a server to hack into, if something's amiss on the perimeter, there's a very small blast radius.

Given the time budget of one hour I was given, I decided not to spin up a fargate task and associated IAM roles, although I really like working with ALBs nowadays.



## Reproducing in your own AWS environment

Terraform code to accomplish this is extremely heavily inspired by https://github.com/alimac/terraform-s3 by https://github.com/alimac. Many credits due there.

These steps assume you have terraform installed.

1. Setup a route53 domain, and a primary zone for it.  route53 hosted zone. Put that info into the variables.tf file.
3. Put the key file in a place where 

## Testing

These steps assume you have the Newman collection runner installed (found here: https://www.getpostman.com/docs/v6/postman/collection_runs/command_line_integration_with_newman)


1. From your bash-like command line run `newman run .mycollection.json

## Production Concerns (or, things I would do with days instead of a couple of hours)
- Write unit tests for the TF code before things even harder to test: https://github.com/newcontext-oss/kitchen-terraform
- Do ALB logging to S3, could ship to Cloudwatch for alerting via SNS.
- As soon as there's IP-secured assets, it would be wise to setup a non-standard VPC to secure and scope the network layer.

## Next steps
- Replace the S3 target with an ECS container for a frontend container like angularcli/nginx