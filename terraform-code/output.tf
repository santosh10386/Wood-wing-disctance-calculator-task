
output "account_creation_link" {
    value = "Link: http://${aws_instance.os.1.public_ip}/"
}


output "elb_DNS" {
    value = "<<<<< Link: http://${module.elb_http.this_elb_dns_name}/   >>>>>>>  ( NOTE: Access after Account Creation.  )"  
}

