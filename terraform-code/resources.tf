# key_creation

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}


resource "local_file" "saving_key" {
   content = "${tls_private_key.example.private_key_pem}"
    filename = "${path.module}/${var.key_name}.pem"
    file_permission = "0400"
}

# Security Group Creation
resource "aws_security_group" "allow_http" {
  name        = "allow_http-ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow Port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_port_80"
  }
}


resource "aws_security_group" "elb_sg" {
  name        = "allow_http_only"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "Allow Port 80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ELB-SG"
  }
}



# Instance Creation
resource "aws_instance" "os" {
  count = length(var.subnet_cidr)
  ami           = var.image
  instance_type = var.i_type
  key_name      = var.key_name
  #security_groups = [aws_security_group.allow_http.name]
  vpc_security_group_ids = [ aws_security_group.allow_http.id ]
  subnet_id =  element(aws_subnet.subnet.*.id, count.index)
  tags = {
     Name = "Webserver-${count.index+1}"
  }

}


# Configuration

resource "null_resource"  "nullremote1" {
    count = length(var.subnet_cidr)    
    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("${path.module}/${var.key_name}.pem")
        host     = element(aws_instance.os.*.public_ip, count.index)
    }

    provisioner "remote-exec" {
        inline = [
        "sudo yum  install docker git  -y",
        "sudo systemctl start docker",
        "sudo systemctl enable docker",
        "sleep 5"
        ]
    }
}

resource "null_resource"  "webserver" {
    depends_on = [null_resource.nullremote1]
    count = length(var.subnet_cidr) 

    connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("${path.module}/${var.key_name}.pem")
        host     = element(aws_instance.os.*.public_ip, count.index)
    }

    provisioner "remote-exec" {
        inline = [
	    "sudo git clone ${var.repo} /webdata ",
            "sudo docker run -dit -p 80:80 -v /webdata/${var.webcode_path}:/usr/local/apache2/htdocs/ --name websrver${count.index+1}  httpd",
            "sudo echo ' Configured over ${element(aws_instance.os.*.public_ip, count.index)}'",
        
        ]
    }
}


# Loadbalancer Creation

module "elb_http" {
  depends_on = [null_resource.webserver]
  source  = "terraform-aws-modules/elb/aws"
  version = "~> 2.0"

  name = "elb-example"

  subnets         = [aws_subnet.subnet.1.id, aws_subnet.subnet.2.id]
  security_groups = [aws_security_group.elb_sg.id]
  internal        = false

  listener = [
    {
      instance_port     = 80
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    },
  ]

  health_check = {
    target              = "HTTP:80/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }
  

 

  // ELB attachments
  number_of_instances = 2
  instances           = [aws_instance.os.1.id, aws_instance.os.2.id ]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}








