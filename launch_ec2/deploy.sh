#!/bin/sh
CONFIG="state-bucket.config"
# TFVARS="production.tfvars"
if [ "$1" = "initialize" ];then
    echo "Terraform Initiazling........."
    terraform init -backend-config=${CONFIG}
elif [ "$1" = "plan" ];then
    terraform init -backend-config=${CONFIG}
    terraform plan 
elif [ "$1" = "apply" ];then
    terraform init -backend-config=${CONFIG}
    terraform apply  -auto-approve
elif [ "$1" = "taint" ];then
    echo "By using the taint command, we can just run the Ansible portion not touching (create or destroy) the AWS instance. For example, we can run terraform apply after just tainting a Null resource "
    terraform taint null_resource.test_box
    #  terraform taint null_resource.jain
    terraform apply --auto-approve
elif [ "$1" = "destroy" ];then
    terraform init -backend-config=${CONFIG}
    terraform destroy  -auto-approve
fi


# ubuntu@ip-100-114-12-235:~$ blkid
# /dev/xvda1: LABEL="cloudimg-rootfs" UUID="e8070c31-bfee-4314-a151-d1332dc23486" TYPE="ext4" PARTUUID="5198cbc0-01"
#    lsblk
#    lsblk -a
#    lsblk -b
#    lsblk -d
#    lsblk -h
#    lsblk -z
#    lsblk -i
#    lsblk -m
#    lsblk -o SIZE,NAME,MOUNTPOINT
#    lsblk -dn
# sudo resize2fs /dev/xvda1 this is for root volume extension after webconsole modify volume

# sudo mkfs -t xfs /dev/xvdf


# #!/bin/sh
# CONFIG="state-bucket.config"
# TFVARS="production.tfvars"
# if [ "$1" = "initialize" ];then
#     echo "Terraform Initiazling........."
#     terraform init -backend-config=${CONFIG}
# elif [ "$1" = "plan" ];then
#     terraform init -backend-config=${CONFIG}
#     terraform plan -var-file=${TFVARS}
# elif [ "$1" = "deploy" ];then
#     terraform init -backend-config=${CONFIG}
#     terraform apply -var-file=${TFVARS} -auto-approve
# elif [ "$1" = "destroy" ];then
#     terraform init -backend-config=${CONFIG}
#     terraform destroy -var-file=${TFVARS} -auto-approve
# fi




# #!/bin/bash 
# CONFIG="state.config"
# TFVARS="var.tfvars"
# echo "${PWD##*/}"
# AWS_BUC_NAME="${PWD##*/}"
# GCC_BUCKET_NAME=$AWS_BUC_NAME-"gcc"
# echo $BUCKET_NAME
# CREATOR="Jain"
# REQUESTOR=JAIN
# # BUCKET_NAME="dcai-dev-mediacorpus-s3-gcc"
# # BUC_NAME="dcai-dev-mediacorpus-s3"

# STATE_CONFIG_CREATION(){
#     echo "Creating state.config for s3 bucket terraform stateManagement ....."
#     # aws s3api get-bucket-policy --bucket $AWS_BUC_NAME --query Policy --profile "jainaws" --output text > policy.json
#     # aws s3api get-bucket-tagging --bucket  $AWS_BUC_NAME --profile "jainaws" --output json > tags.json
#     echo 'key="S3-BUCKET-TFSTATE/'$GCC_BUCKET_NAME'.tfstate"' >state.config
#     echo 'bucket="terraform-s3bucket-states-gcc"' >> state.config
#     echo 'region="ap-southeast-1"' >> state.config
# }

# VARS_DOT_TF_CREATION(){
#     echo "Creating var.tfvars file"
#     echo 'agency_name="na"' >var.tfvars
#     echo 'project_code="na"' >>var.tfvars
#     echo 'app_name="na"' >>var.tfvars
#     echo 'purpose="na"' >>var.tfvars
#     echo 'env_name="dev"' >>var.tfvars
#     echo 'bucket_name="'$GCC_BUCKET_NAME'"' >>var.tfvars
#     echo 'requestor="'$REQUESTOR'"' >>var.tfvars
#     echo 'creator="'$CREATOR'"' >>var.tfvars
#     terraform fmt
# }



# if [ $1 = "plan" ]; then 
#     echo "Rinning terraform plan"
#     terraform init -backend-config=${CONFIG}
#     terraform plan -var-file=${TFVARS}
# elif [ $1 = "apply" ]; then
#     INIT 
#     terraform init -backend-config=${CONFIG}    
#     terraform apply -var-file=${TFVARS} -auto-approve
#     rm -rf .terraform*
# elif [ $1 = "destroy" ]; then 
#     terraform init -backend-config=${CONFIG}    
#     terraform destroy -var-file=${TFVARS} -auto-approve
# elif [ $1 = "copy" ]; then

# fi







