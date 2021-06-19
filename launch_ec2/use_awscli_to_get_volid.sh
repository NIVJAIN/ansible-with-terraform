# Get EC2 Instance ID from Terraform Output
INSTANCE_ID=$(terraform show | grep -A 1 aws_instance.nginx | tail -n 1 | awk '{print $3}')
echo $INSTANCE_ID
# Get the /dev/sdg volume details from AWS CLI
# aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$INSTANCE_ID --filters Name=attachment.device,Values=/dev/sda1

# Use jq to scope those details down to just Volume ID
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$INSTANCE_ID --filters Name=attachment.device,Values=/dev/sda1 | jq -r '.Volumes[].VolumeId'