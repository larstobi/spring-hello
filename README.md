Instruksjoner
=============
```
brew install terraform vaulted awscli
git clone https://github.com/larstobi/spring-hello.git
cd spring-hello/terraform
vaulted add capra-private
```
* Legg inn credentials (access key og secret + mfa arn).
* OBS! Uten mfa arn vil det ikke fungere.
```
vaulted shell capra-private
aws sts get-caller-identity
```
* Edit `terraform.tfvars` og copy-paste inn `aws_account_id` fra `Account` i output.

```
terraform init
terraform plan
```
* Se på output
```
terraform apply 
```
* Se på output og skriv `yes` og <enter>.
```
aws --region eu-west-1 codebuild start-build --project-name hello
aws --region eu-west-1 ecr list-images --repository-name hello
```
* Hvis tom liste i output, vent litt og kjør list-images igjen inntil man får ut en hash.
* Edit `terraform.tfvars` og bytt it image digest med output fra ecr list.
* Kjør `terraform apply` igjen.
* Vent et par minutter og kjør curl mot output fra `terraform apply`: `load_balancer_hostname`
```
curl hello-alb-957278671.eu-west-1.elb.amazonaws.com/
```
* Hvis 200 OK og Greetings så er du i mål! :-D
