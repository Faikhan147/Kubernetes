#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Install eksctl
# -----------------------------------
echo "Installing eksctl..."
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"
tar -xvzf eksctl_$(uname -s)_amd64.tar.gz
sudo mv eksctl /usr/local/bin
eksctl version  # Verify installation

# -----------------------------------
# Associate IAM OIDC provider with cluster
# -----------------------------------
echo "Associating IAM OIDC provider..."
eksctl utils associate-iam-oidc-provider \
  --region ap-south-1 \
  --cluster Monitoring \
  --approve

# -----------------------------------
# Delete old CloudFormation stack
# -----------------------------------
echo "Deleting old CloudFormation stack if exists..."
aws cloudformation delete-stack \
  --stack-name eksctl-Monitoring-addon-iamserviceaccount-kube-system-ebs-csi-controller-sa \
  --region ap-south-1

# -----------------------------------
# Create IAM service account for EBS CSI driver
# -----------------------------------
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster Monitoring \
  --region ap-south-1 \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --override-existing-serviceaccounts

# -----------------------------------
# Deploy EBS CSI driver
# -----------------------------------
echo "Deploying EBS CSI driver..."
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.28"

# -----------------------------------
# Verify pods
# -----------------------------------
echo "Checking EBS CSI driver pods..."
kubectl get pods -n kube-system | grep ebs

echo "Script completed successfully!"






chmod +x setup_ebs_driver.sh
./setup_ebs_driver.sh
