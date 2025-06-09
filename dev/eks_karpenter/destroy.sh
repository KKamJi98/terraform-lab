#!/bin/bash

echo "Starting EKS cluster cleanup process..."

echo "Step 1: Deleting all NodeClaims..."
kubectl delete nodeclaims --all
echo "NodeClaims deleted."

echo "Step 2: Deleting all NodePools..."
kubectl delete nodepools --all
echo "NodePools deleted."

echo "Step 3: Deleting all EC2NodeClasses..."
kubectl delete ec2nodeclasses --all
echo "EC2NodeClasses deleted."

echo "Step 4: Running Terraform destroy..."
terraform destroy -auto-approve

echo "EKS cluster cleanup completed."
