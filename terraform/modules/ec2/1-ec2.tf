provider "aws" {
  region = var.region
   default_tags {
   tags = var.default_tags
 }
  # ignore_tags {
  #   keys = ["LastScanned"]
  # }
}



# terraform {
#   backend "s3" {}
# }

resource "aws_instance" "nginx" {
  /* ami = "ami-02a3575cbd0c8c096" # amzon linux */
  # name_prefix = format("%s-%s", var.project_name,"EC2")
  ami                         = var.ami_id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
    # security_groups             = [aws_security_group.nginx.id]  dont use this , when you re run terraform, it will destory and will recreate the resources.
  vpc_security_group_ids             = [aws_security_group.nginx.id]
  key_name                    = var.key_name

  root_block_device {
      volume_type = "gp2"
      volume_size = var.root_volume_size
      tags = {
        Name = "${var.project_name}-ROOT-BLK"
      }
  }

 tags = merge(
    var.default_tags,
    {
     Name = "{var.project_name}-EC2"
    }
  )
  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      tags,
    ]
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
    # inline = [
    #   "chmod +x /tmp/start_node.sh",
    #   "sudo sed -i -e 's/\r$//' /tmp/start_node.sh", # Remove the spurious CR characters.
    #   "sudo /tmp/start_node.sh",
    # ]
    connection {
      type        = "ssh"
      user        = var.ssh_username
      # private_key = file(var.private_key_path)
      private_key = var.private_key_path
      host        = aws_instance.nginx.public_ip
    }
  }


  # provisioner "local-exec" {
  #   command = "ansible-playbook  -i ${aws_instance.nginx.public_ip}, --private-key ${var.private_key_path} nginx.yaml"
  # }
  # provisioner "local-exec" {
  #   command = "echo ssh -i vamakp.pem ubuntu@${aws_instance.nginx.public_ip} > ubuntu.sh"
  # }
}


# resource "aws_ebs_volume" "data-vol" {
#   depends_on        = [aws_instance.nginx]
#   availability_zone = "${aws_instance.nginx.availability_zone}"
#   type       = "gp2"
#   size              = "15"
# tags = merge(
#     var.default_tags,
#     {
#      Name = "Terraform-EBS"
#     }
#   )
#   lifecycle {
#     ignore_changes = [
#       # Ignore changes to tags, e.g. because a management agent
#       # updates these based on some ruleset managed elsewhere.
#       tags,
#     ]
#   }
# }


# resource "aws_volume_attachment" "good-morning-vol" {
# #  device_name = "/dev/sdh"
#  device_name = "/dev/xvdh"
#  volume_id = "${aws_ebs_volume.data-vol.id}"
#  instance_id = "${aws_instance.nginx.id}"
#    skip_destroy = false
#   force_detach = true
# }


# // volumes.tf
# resource "aws_ebs_volume" "mysql" {
#   availability_zone = "ap-southeast-1"
#   size = 10
#   type = "gp2"
#   tags {
#     Name      = "mysql"
#     Role      = "db"
#     Terraform = "true"
#     FS        = "xfs"
#   }
# }

# resource "null_resource" "test_box" {
#   depends_on = [aws_instance.nginx]
#   connection {
#     host = "${aws_instance.nginx.0.public_ip}"
#     # private_key = "${file("./test_box")}"
#     private_key = var.private_key_path
#   }
#   provisioner "ansible" {
#     plays {
#       playbook {
#         file_path = "nginx_ansible.yaml"
#         roles_path = ["/roles"]
#         force_handlers = false
#         # skip_tags = ["list", "of", "tags", "to", "skip"]
#         # start_at_task = "task-name"
#         # tags = ["list", "of", "tags"]
#       }
#       hosts = ["aws_instance.nginx.*.public_ip"]
#       groups = ["consensus"]
#     }
#   }
# }

# resource "null_resource" "test_box" {
#   depends_on = "aws_instance.test_box"
#   connection {
#     host = "${aws_instance.test_box.0.public_ip}"
#     private_key = "${file("./test_box")}"
#   }
#   provisioner "ansible" {
#     plays {
#       playbook {
#         file_path = "/path/to/playbook/file.yml"
#         roles_path = ["/path1", "/path2"]
#         force_handlers = false
#         skip_tags = ["list", "of", "tags", "to", "skip"]
#         start_at_task = "task-name"
#         tags = ["list", "of", "tags"]
#       }
#       hosts = ["aws_instance.test_box.*.public_ip"]
#       groups = ["consensus"]
#     }
#   }
# }