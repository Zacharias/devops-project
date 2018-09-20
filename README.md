# devops-project

I'm choosing to host the content from S3. I chose S3 because it is free-tier, serverless (which means less security surface area), and fast. If there isn't a server to hack into, if something's amiss on the perimeter, there's a very small blast radius. Given the time budget of one hour, I decided not to spin up a fargate task and associated IAM roles, although I really like working with ALBs nowadays.
 
https://demo.2628collins.com (has ssl errors because I'm using the cloudformation ssl template)
http://d2ysurhkixaycu.cloudfront.net redirects to https
https://d2ysurhkixaycu.cloudfront.net works

## Reproducing in your own AWS environment

Terraform code to accomplish this is extremely heavily inspired by https://github.com/alimac/terraform-s3 by https://github.com/alimac. Many/most credits due to Ali. I haven't used CloudFormation before this go-around, and I think it's a wonderful tool for managing the simple stuff at scale.

These steps assume you have terraform installed.

1. `$ mv exampleterraform.replacementfvars terraform.tfvars`
2. Setup a route53 domain, and a primary zone for it. Just a route53 hosted zone. Put that info into the terraform.tfvarsfile.
3. terraform plan
4. terraform apply

## Testing

These steps assume you have the Newman collection runner installed (found here: https://www.getpostman.com/docs/v6/postman/collection_runs/command_line_integration_with_newman)

1. From your bash-like command line (at the root of this repo) run `newman run ./test/MyCoolCollection.postman.json --ignore-redirects`

## Production Concerns (or, things I would do with days instead of a couple of hours)
- Write unit tests for the TF code before things even harder to test: https://github.com/newcontext-oss/kitchen-terraform
- Loggins
- As soon as there's IP-secured assets, it would be wise to setup a non-standard VPC to secure and scope the network layer.
- Integration tests against the s3 bucket in case they pop open public, which seems like half of the last year's worth of high-profile data leaks.

## Next steps
- Replace the S3 target with an ECS container for a frontend container like angularcli/nginx
