brew install terraform vaulted awscli
git clone https://github.com/larstobi/spring-hello.git
cd spring-hello/terraform

vaulted add capra-private
   < legg inn credz >
   < OBS! legg også inn mfa arn >

vaulted shell capra-private
aws sts get-caller-identity

Edit "terraform.tfvars"
---
**NOTE**
Legg inn aws_account_id
---

terraform init
terraform plan
  < se på output >

terraform apply 
  < se på output og skriv yes + enter >

aws --region eu-west-1 codebuild start-build --project-name hello
aws --region eu-west-1 ecr list-images --repository-name hello
Hvis tom, vent litt og kjør list-images igjen inntil man får ut en hash.
Edit “terraform.tfvars” og bytt it image digest med output fra ecr list.
Kjør “terraform apply” igjen.
Vent et par minutter og kjør curl mot output fra “terraform apply”: load_balancer_hostname
curl hello-alb-957278671.eu-west-1.elb.amazonaws.com/
Hvis 200 OK og Greetings så er du i mål! :-D
