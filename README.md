brew install terraform vaulted
git clone https://github.com/larstobi/spring-hello.git
cd spring-hello/terraform
vaulted add capra-private
   < legg inn info >


vaulted shell capra-private
terraform init
terraform plan
  < se på output >

terraform apply 
  < se på output og skriv yes + enter >

