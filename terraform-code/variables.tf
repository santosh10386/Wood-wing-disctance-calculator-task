/*
variable "account_id" {
    description = "AWS Access key"
}

variable "account_pass" {
    description = "AWS Secret Key"
}
*/

variable "account_profile" {
    default = "default"
    description = "Profile Authentication Method Terraform"
}

variable "aws_region" {
    default = "ap-south-1"
    description = "Region where VPC Created"
}



variable "vpc_cidr" {
    default  = "10.0.0.0/16"
    description = "CIDR of the VPC to be created"
}

variable "vpc_name" {
    default = "web-mysql VPC"
    description = "Desired Name of VPC"
}

variable "subnet_cidr" {
    default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
    type = list
    description = "List of Subnet to be created"
}


variable "azs" {
    default = ["ap-south-1a","ap-south-1b","ap-south-1a"]
    type = list
    description = "List of Availabily Zones. It is in sequence with subnet_cidr"
}

variable "image" {
    type=string
    description="AWS AMI ID"
  
}
variable "i_type" {
    default = "t2.micro"
    description = "AWS EC2 Instance Type"
}

variable "key_name" {
    default = "mytfkey"
    description = "Desired SSH Keyname. It will create new Key"
}

