## Resources Provisioned in this directory
1. VPC - 1
2. Subnet - 4(2 Public, 2 Private) - in 2AZs
3. Internet Gateway
4. Route Table - For Public Subnets
5. Elastic IP - 2 - For NAT Gateway
6. NAT Gateway - 2 
7. Route Table - 2 - To allow internet connectivity
8. IAM roles
9. EKS Cluster
10. Addons for EKS Cluster
11. Node Group

## Commads to provision resources
1. cd 02-eks-aws-provisioning
2. aws configure
3. terraform init
4. terraform plan
5. terraform apply
6. aws eks update-kubeconfig --name cluster-learn
7. K8s commands - Refer https://kubernetes.io/docs/tutorials/stateless-application/guestbook/ for detailed reference
    - Verify the nodes(ec2 instances)
        - kubectl get nodes
    - Create Deployment and Services 
        - kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-deployment.yaml
        - kubectl apply -f https://k8s.io/examples/application/guestbook/redis-leader-service.yaml
        - kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-deployment.yaml
        - kubectl apply -f https://k8s.io/examples/application/guestbook/redis-follower-service.yaml
        - kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-deployment.yaml
        - kubectl apply -f https://k8s.io/examples/application/guestbook/frontend-service.yaml
    - Verify Pods and Services
        - kubectl get pods
        - kubectl get services
    - Verify the application
        - kubectl port-forward svc/frontend 8080:80
        - open up http://localhost:8080/ in browser and check
    - Cleanup
        - kubectl delete deployment -l app=redis
        - kubectl delete service -l app=redis
        - kubectl delete deployment frontend
        - kubectl delete service frontend
6. terraform destroy
