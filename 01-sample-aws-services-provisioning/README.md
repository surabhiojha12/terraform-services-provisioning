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

