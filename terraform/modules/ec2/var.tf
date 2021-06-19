variable "region" {
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable "project_name" {
  default = "project_name"
  description = "Project name,this name will be used for naming resources"
}

variable "vpc_id" {
  default     = "vpc-028b7724ac0331752"
  description = "AWS Region"
}

variable "ami_id" {
  default = "ami-0d058fe428540cd89"
  description = "AMI Image ID"
   validation {
    # regex(...) fails if it cannot find a match
    condition     = can(regex("^ami-", var.ami_id))
    error_message = "The ami_id value must be a valid AMI id, starting with \"ami-\"."
  }
}

variable "subnet_id" {
  default = "subnet-08b1ad0d7506dca3f"
  description = "SUBNET ID"
}

variable "instance_type" {
  default = "t2.micro"
  description = "EC2 Instance type"
}

variable "associate_public_ip_address" {
  default = true
}

variable "ssh_username" {
  default = "ubuntu"
  description = "SSH user name to ssh to ec2 for ansible"
}

variable "key_name" {
  default = ""
  description = "pem file key name, without .pem"
}

variable "private_key_path" {
  default = "./"
  description = "pem file path"
}

variable "instance_name" {
  default = "someinstance"
  description = "name of the ec2 instance"
}

variable "default_tags" {
  default = {
     Environment = "Dev"
     Owner       = "TFProviders"
     Project     = "Test"  
     Requestor   = "User"
     Creator     = "CloudTFEngineer" 
  }
}

variable "public_subnets" {
  type        = list(string)
  default     = ["subnet-08b1ad0d7506dca3f","subnet-0e13dde65836782b9"]
  description = "List of availability zones for the selected region"
}

variable "jump_host_security_group" {
  type        = list(string)
  default     = ["sg-021bf7f871be99f3e", "sg-05057e074f565c0fa", "sg-0cc362e87c48e58ce"]
  description = "List of jumphost sg group"
}

variable "jump_hosts_ip" {
  type        = list(string)
  default = ["116.86.133.133/32"]
  description = "Client laptops ip"
}

variable "client_laptops_ip" {
  type        = list(string)
  default = ["116.86.133.133/32"]
  description = "Client laptops ip"
}

variable "domain_name" {
  default = "aipo-imda.net"
  description = "domain name for route53"
}

variable "domain_host_name" {
  default = "random"
  description = "Host name of the domain"
}

variable "availability_zones" {
  # type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  description = "List of availability zones for the selected region"
}

variable "health_check" {
  default =  {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 10
    path                = "/"
  }
}

# variable "docker_ports" {
#   type = list(object({
#     internal = number
#     external = number
#     protocol = string
#   }))
#   default = [
#     {
#       internal = 8300
#       external = 8300
#       protocol = "tcp"
#     }
#   ]
# }

# variable "hosts" {
#   type =list(map(string)) 
# }

variable "hosts2" {
  # type = "map"
  default = {
    "nginx" = {
      "tgport"  = "8080"
      "tgproto" = "HTTP"
    },
    "rabbit" = {
      "tgport"  = "15672"
      "tgproto" = "HTTP"
    }
  }
}
# variable "services_map" {
#   default = {
#     "nginx"    = "8080"
#     "rabbit"   = "15672"
#     "rabbitmq" = "5672"
#   }
# }

variable "nlb_config"  {
  # type = "map"
  default = {
    internal    = "false"
    environment = "Dev"
  }
}
variable "tg_config"  {
  # type = "map"
  default = {
    target_type           = "instance"
    health_check_protocol = "TCP"
  }
}

variable  "forwarding_config" {
  # type = "map"
  default = {
     5672 = "TCP"
  }
}

variable "ansible_playbook" {
  description = "ansible playbook file name"
  default = ""
}

variable "root_volume_size" {
  default = "8"
  description = "name of the ec2 instance"
}