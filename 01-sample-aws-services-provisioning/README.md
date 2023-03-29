## Resources Provisioned in this directory
1. VPC - 1
2. Subnet - 4(2 Public, 2 Private) - in 2AZs
3. Internet Gateway
4. Route Table - For Public Subnets
5. Elastic IP - For NAT Gateway
6. NAT Gateway - 1 - in 1AZ(1 Public Subnet)
7. Route Table - For 1 Private Subnet - To allow internet connectivity
8. Security Group - 1 - For ALB
9. Target Group - 2 - for ALB
10. ALB - 1
11. Security Group - For EC2 instances
12. EC2 instaces - 2 - in each Private subnets.

## High level architecture
![terraform](https://user-images.githubusercontent.com/30311373/227195970-7dbed23a-3c19-406b-b4a3-68404c75de93.png)

## Commads to provision resources
1. cd 01-sample-aws-services-provisioning
2. aws configure
3. terraform init
4. terraform plan
5. terraform apply
6. terraform destroy

## Verify the setup by running the http server
- There are 2 EC2 instances running 2 different servers.
- One instance makes call to internet and runs a http server based on that result.
- The other instance run a simple http server.
- Once the ALB is up and running follow these steps:-
    - Copy DNS name of ALB and run it in Web Browser
    - The ALB redirects the request to EC2 instance(without internet access) if there is no path({DNS-name}).
      <img width="492" alt="Screenshot 2023-03-23 at 5 36 19 PM" src="https://user-images.githubusercontent.com/30311373/227198916-595d3997-0e09-4e93-8ea7-fa1186d58a80.png">
    - The ALB redirects the request to EC2 instance(with internet access) if the path is {DNS-name}/index.html
      <img width="1440" alt="Screenshot 2023-03-23 at 5 33 44 PM" src="https://user-images.githubusercontent.com/30311373/227198744-1f3ee5c4-1f94-40a8-9a71-7d3c41f384b4.png">

