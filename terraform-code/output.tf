output "elb_DNS" {
    value = "<<<<< Website Link: http://${module.elb_http.this_elb_dns_name}/   >>>>>>> ( wait 60 sec for elb healthcheck )"  
}

