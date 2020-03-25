#
# EKS Worker Nodes Resources
#  * IAM role allowing Kubernetes actions to access other AWS services
#  * EKS Node Group to launch worker nodes
#

resource "aws_iam_role" "demo-node" {
  name = "terraform-eks-demo-node"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# properly configure Kubernetes applications on the EC2 instance.
# We utilize a Terraform local here to simplify Base64 encode this
# information and write it into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  tf-eks-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.tf_eks.endpoint}' --b64-cluster-ca '${aws_eks_cluster.tf_eks.certificate_authority.0.data}' '${var.eks_cluster-name}'
apt-get update
apt-get install docker -y
service docker start
docker run -d -p 80:80 nginx
USERDATA
}
 
resource "aws_launch_configuration" "tf_eks" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.node.name}"
  image_id                    = "${data.aws_ami.eks-worker.id}"
  instance_type               = "m4.large"
  name_prefix                 = "terraform-eks"
  security_groups             = ["${aws_security_group.tf-eks-node.id}"]
  user_data_base64            = "${base64encode(local.tf-eks-node-userdata)}"
  key_name                    = "${var.keypair-name}"
 
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_launch_configuration" "demo" {
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.demo-node.name
  image_id = data.aws_ami.eks-worker.id
  instance_type = "t2.micro"
  key_name = "home"
  name_prefix = "terraform-eks-demo"
  security_groups = [aws_security_group.demo-node.id]
  user_data_base64 = base64encode(local.demo-node-userdata)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.demo-node.name
}

resource "aws_iam_role_policy_attachment" "demo-node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.demo-node.name
}

resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo"
  node_role_arn   = aws_iam_role.demo-node.arn
  subnet_ids      = aws_subnet.demo[*].id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-node-AmazonEC2ContainerRegistryReadOnly,
  ]
}
