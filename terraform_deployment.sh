# make sure terraform is installed before running this file
## this command refreshes the terraform current state to find changes and valids for errors
terraform plan -out deploy_plan

# this command apply all changes made as per the terraform config.
terraform apply
