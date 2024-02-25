# eks_cluster
Deploys EKS Cluster

https://tf-eks-workshop.workshop.aws/500_eks-terraform-workshop/510_scenario.html

https://github.com/kjpark/terraform-aws-eks-vpc-cni-custom-networking/blob/main/eniconfig.tf

https://github.com/aws-samples/terraform-cni-custom-network-sample/blob/main/scripts/network.sh


https://marcincuber.medium.com/amazon-eks-add-ons-implemented-with-terraform-66a49fad4174

https://shisho.dev/dojo/providers/aws/Amazon_EKS/aws-eks-addon/

https://medium.com/@alex.veprik/setting-up-aws-eks-cluster-entirely-with-terraform-e90f50ab7387

https://github.com/aidanmelen/terraform-aws-eks-auth/blob/v1.0.0/main.tf

https://dev.to/fukubaka0825/manage-eks-aws-auth-configmap-with-terraform-4ndp

https://tech.now.gg/how-to-setup-eks-oidc-on-aws-with-terraform-df02364d1cda

https://aws-ia.github.io/terraform-aws-eks-blueprints/

https://github.com/terraform-aws-modules/terraform-aws-iam/blob/master/modules/iam-role-for-service-accounts-eks/main.tf

https://medium.com/@chauhanhimani512/deploying-dockerized-app-on-aws-eks-cluster-using-argocd-and-gitops-methodology-with-circleci-71983375e550


https://www.linkedin.com/pulse/devops-project-14-step-by-step-implementation-chetan-r-ufdmc?utm_source=share&utm_medium=member_ios&utm_campaign=share_via

https://dev.to/kelvinskell/advanced-end-to-end-devops-project-deploying-a-microservices-app-to-aws-eks-using-terraform-helm-jenkins-and-argocd-part-i-3a53

# Self Managed

With self managed, you build and maintain the ship. You specify your EC2 instance and AMI image (i.e Bottlerocket, Firecracker, Windows) You have more to do when patching your nodes and have complete control of the instance.

# Managed Node

AWS manages the servers for you - You just specify the instance type, but not the AMI. Patching can be managed for you.

# Fargate

The last type of node group is Fargate - This is like giving your container to someone else to ship. You don't have a ship. Your container runs on a node with other customers and you are only billed for the compute you use, not the whole node or empty ship. This is considered serverless since you don't provision or maintain servers with this node group type.


# Best Practices

https://spacelift.io/blog/kubernetes-best-practices

https://collabnix.com/15-kubernetes-best-practices-every-developer-should-know/

https://medium.com/@vinoji2005/using-terraform-with-kubernetes-a-comprehensive-guide-237f6bbb0586