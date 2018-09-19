#devops-project

Given the use case of a static web application, I'm choosing to host the content from S3. I chose S3 because it is free-tier, serverless (which means less security surface area), and fast. 

I chose an ALB to front the s3 bucket to ensure the ssl/https setup wasn't strictly coupled to a target, for example, if the config was strictly 

Given the time budget of one hour I was given, I decided not to spin up a fargate task and associated IAM roles.

## Reproducing in your own AWS environment

These steps assume you have terraform installed.

0. Setup varibales for your VPC id, 
1. Setup a route53 hosted zone. Put that info into the variables.tf file.
2. Setup a let's encrypt certificate for that domain
3. Put the key file in a place where 

## Production Concerns (or, things I would do with days instead of a couple of hours)
- Write unit tests for the TF code before things even harder to test: https://github.com/newcontext-oss/kitchen-terraform
- Do ALB logging to S3, could ship to Cloudwatch for alerting via SNS.
- As soon as there's IP-secured assets, it would be wise to setup a non-standard VPC to secure and scope the network layer.

## Next steps
- Replace the S3 target with an ECS container for a frontend container like angularcli/nginx