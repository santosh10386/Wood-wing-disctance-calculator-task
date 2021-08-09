// Terraform Varaibles Configuration File

// Authentication
account_profile      = "default"
// account_id = "xxxxxxxx"
//account_pass = "xxxxxxxxx"

//VPC
aws_region = "ap-south-1"
vpc_cidr = "10.0.0.0/16"
vpc_name = "Kareen VPC"
subnet_cidr = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
azs = ["ap-south-1a","ap-south-1b","ap-south-1a"]       # should be sinc with subnet_cidr

// Instance

image = "ami-04db49c0fb2215364"     # uncomment and update ami-id
i_type = "t2.micro"                 # Instance Type
key_name = "mytfkey"                # Desired SSH Keyname. It will create new Key

