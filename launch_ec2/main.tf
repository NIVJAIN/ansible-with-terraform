# ------------------------------------------------------------------------------
# PROVIDER
# ------------------------------------------------------------------------------
provider "aws" {
  region  = local.aws_region
  profile = "default"
   ignore_tags {
    keys = ["LastScanned"]
  }
}

# ------------------------------------------------------------------------------
# TERRAFORM VERSION
# ------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

terraform {
  backend "s3" {}
}

# ------------------------------------------------------------------------------
# SETUP FIXED values
# ------------------------------------------------------------------------------
locals {
  project_name = "VAMA-2"
  region           = "ap-southeast-1"
  vpc_id           = "vpc-028b7724ac0331752"
  ami_id           = "ami-0d058fe428540cd89"
  subnet_id        = "subnet-08b1ad0d7506dca3f"
  instance_type    = "t2.medium"
  ssh_username     = "ubuntu"
  key_name         = "vamakp"
  root_volume_size = "80"
  private_key_path = file("${path.module}/vamakp.pem")
  # ansible_playbook = "./nginx_ansible.yaml"
  # private_key_path = "../../launch_ec2/vamakp.pem"
  ansible_playbook = "${path.module}/../ansible/nginx.yaml"
  # private_key_path = "./vamkp.pem"
  # ansible_playbook = "./nginx_ansible.yaml"
  instance_name    = "Gibralta"
  default_tags = {
    Environment = "Dev"
    Owner       = "Jain"
    Requestor   = "User"
    Creator     = "TerraformScriptWithAnsible"
  }
  public_subnets           = ["subnet-08b1ad0d7506dca3f", "subnet-0e13dde65836782b9"]
  jump_host_security_group = ["sg-021bf7f871be99f3e", "sg-05057e074f565c0fa", "sg-0cc362e87c48e58ce"]
  client_laptops_ip        = ["116.86.133.133/32"]
  jump_hosts_ip            = ["10.196.250.8/32"]
  domain_name              = "aipo-imda.net"
  domain_host_name          = "rabbitmq"
  availability_zones       = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  health_check = {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 5
    interval            = 10
    path                = "/"
  }
  hosts2 = {
    "nginx" = {
      "tgport"  = "8080"
      "tgproto" = "HTTP"
    },
    "rabbit" = {
      "tgport"  = "15672"
      "tgproto" = "HTTP"
    },
    "nodeapp" = {
      "tgport"  = "3000"
      "tgproto" = "HTTP"
    },
    "service" = {
      "tgport"  = "5000"
      "tgproto" = "HTTP"
    }
  }
  nlb_config = {
    internal    = "false"
    environment = "Dev"
  }
  tg_config = {
    target_type           = "instance"
    health_check_protocol = "TCP"
  }
  forwarding_config = {
    5672 = "TCP"
  }
}

module "s3" {
  source          = "../terraform/modules/ec2"
  project_name = local.project_name
    region           = local.region
  vpc_id           = local.vpc_id
  ami_id           = local.ami_id
  subnet_id        = local.subnet_id
  instance_type    = local.instance_type
  ssh_username     = local.ssh_username
  key_name         = local.key_name
  private_key_path = local.private_key_path
  root_volume_size = local.root_volume_size
  instance_name    = local.instance_name
  default_tags = local.default_tags
  public_subnets           = local.public_subnets
  jump_host_security_group = local.jump_host_security_group
  client_laptops_ip        = local.client_laptops_ip
  jump_hosts_ip            = local.jump_hosts_ip
  domain_name              = local.domain_name
  domain_host_name          = local.domain_host_name
  availability_zones       = local.availability_zones
  health_check = local.health_check
  hosts2 = local.hosts2
  nlb_config = local.nlb_config
  tg_config = local.tg_config
  forwarding_config = local.forwarding_config
  ansible_playbook = local.ansible_playbook

}

output "nginx_ip" {
  value = module.s3.nginx_ip
}

resource "null_resource" "test_box" {
  depends_on = [
    module.s3
  ]

  provisioner "local-exec" {
  # command = "ansible-playbook  -i ${module.ec2.aws_instance.nginx.public_ip}, --private-key ${local.private_key_path} nginx_ansible.yaml"
  # command = "ansible-playbook  -i ${module.s3.nginx_ip}, --private-key ${local.private_key_path} nginx.yaml"
  # command = "ansible-playbook  -i ${module.s3.nginx_ip}, --private-key vamakp.pem nginx.yaml"
  # command = "ansible-playbook  -i localhost, --private-key vamakp.pem ../ansible/nginx.yaml" 
  #  command = "ansible-playbook  -i localhost ../ansible/nginx.yaml"
   command = "ansible-playbook  -i ${module.s3.nginx_ip}, --private-key vamakp.pem ${local.ansible_playbook}"
  # command = "ansible-playbook  -i localhost ${local.ansible_playbook}"
 }

  provisioner "local-exec" {
    command = <<-EOT
      echo "Create sh files for ec2 ssh login and running playbook during development work"
      echo ssh -i vamakp.pem ubuntu@${module.s3.nginx_ip} > ubuntu.sh
      echo ansible-playbook -i ${module.s3.nginx_ip}, --user ubuntu --private-key vamakp.pem ansible_playbook > run_playbook.sh
    EOT
  }
}

# resource "null_resource" "jain" {
#    provisioner "local-exec" {
#    command = "echo ${path.module}/../ansible/nginx.yaml"
#   }
# }












 # provisioner "local-exec" {
  #  command = "echo ${local.ansible_playbook}"
  # }

  # provisioner "local-exec" {
  #   # command = "echo ssh -i vamakp.pem ubuntu@${module.s3.nginx_ip} > ubuntu.sh"
  # }












# provisioner "local-exec" { 
#   interpreter = ["/bin/bash" ,"-c"]
#   command = <<-EOT
#     exec "command1"
#     exec "command2"
#   EOT
#  "echo # ansible-playbook -i ${module.s3.nginx_ip}, --user ubuntu --private-key vamakp.pem nginx.yaml >> ubuntu.sh"
# }
# provisioner "local-exec" {
#     command = <<EOT
#       echo Host ${aws_instance.bastion.public_ip} >> ${var.local_ssh_config};
#       echo IdentityFile ${var.local_identity_file} >> ${var.local_ssh_config}
#    EOT
# }

# resource "null_resource" "ProvisionRemoteHostsIpToAnsibleHosts" {
#   count = "${var.instance_count}"
#   connection {
#     type = "ssh"
#     user = "${var.ssh_user_name}"
#     host = "${element(aws_instance.myInstanceAWS.*.public_ip, count.index)}"
#     private_key = "${file("${var.ssh_key_path}")}"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "sudo yum update -y",
#       "sudo yum install python-setuptools python-pip -y",
#       "sudo pip install httplib2"
#     ]
#   }
#   provisioner "local-exec" {
#     commandgi = "echo ${element(aws_instance.myInstanceAWS.*.public_ip, count.index)} >> hosts"
#   }
# }

# ansible-playbook -i 18.138.58.120, --user ubuntu --private-key vamakp.pem nginx.yaml

#  terraform taint null_resource.ModifyApplyAnsiblePlayBook
# terraform taint null_resource.test_box