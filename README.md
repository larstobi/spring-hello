brew install terraform vaulted
git clone https://github.com/larstobi/spring-hello.git
cd spring-hello/terraform
vim terraform.tfvars
   < editer aws_account_id >
vaulted add capra-private
   < legg inn info >


vaulted shell capra-private
terraform init
terraform plan
  < se på output >

terraform apply 
  < se på output og skriv yes + enter >



aws —region eu-west-1 codebuild start-build --project-name hello

aws ecr list-images --repository-name hello

