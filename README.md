## Project scope
```
1. Deploy ec2 instance
2. create ALB loadbalancer
3. create NLB loadbalancer
4. Create security groups for ALB, NLB and for EC2
5. ALB load balancer open ports 80 & 443
6. Terraform will perfrom ALB host forwardning to rabbitmq.aipo-imda.net , nodeapp.aipo-imda.net, service.aipo-imda.net
7. Terraform wiill update route53 records in AWS for item 6.
8. Terraform state management will be stored in s3 bucket.
9. Also take note donot git commit pem files to git repo. use .gitignore to ignore pem files.
```

## Terraform with ansible integration
```
1. Terraform will perfrom ALB host forwarning
   1. rabbitmq.aipo-imda.net (this is for rabbitmq managerment listeing on port 15672)
   2. nodeapp.aipo-imda.net (this is sample app listening to port 3000)
   3. service.aipo-imda.net (microservices running onport 5000 and inter services service-a,service-b,service-3 are not exposed)
2. NLB, will create target group for nlb for port 5672 communication this for layer4.
3. Below items Ansible playbook will install
    1. Installation of docker, docker-compose, python, nodejs and nvm installation
    2. 'apt-transport-https', 'ca-certificates', 'curl', 'software-properties-common', 'python3-pip', 'virtualenv', 'python3-setuptools'
    3. cp of local folder of rabitmq cluster from folder of ansible/rabbitmq-cluster_docker_compose to remote ec2 /home/ubuntu/rabbitmq-cluster_docker_compose
    4. cp of node-mongo-docker folder to ec2 to /home/ubuntu/node-mongo-docker
    5. ansible will auto run the docker-compose build - up command for item 2 and 3.

```

## How to run
```
1. install aws-cli
2. aws configure (get your secret key and access key for terraform deployment)
3. cd launc_ec2
4. sh deploy plan
5. sh deploy apply
6. sh deploy destory (this will destory all cloud resources)
7. sh deploy taint (only want to execute ansible playbook use this command)
```

### Task lists
1. [x] Update README
2. [x] Convert EC2 into terraform module
3. [x] Integrate ALB to EC2
4. [x] Update ALB with HOST Forwarding rules
5. [x] Hard coded target groups for loadbalancers, convert it to dynamic.
6. [x] convert **count** variable to **for_each**, which is latest from terraform version 12 onwards
7. [ ] move out ansible playbook from terraform module of ec2 to launch_ec2 of main.tf
8. [ ] Integrate **Hashi Vault**, for secret key management
9. [ ] make security group dynamic generator
10. [x] Execute ansible playbooks individually without terraform. via **sh deploy taint**  command
11. [ ] incomplete
12. [x] completed
13. [x] convert host2 variable to maps