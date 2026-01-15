#!/bin/bash

# --- 스크립트 설정 ---
# Terraform의 `locals { name = "..." }` 값과 동일하게 설정해주세요.
CLUSTER_NAME="kkamji-al2023"

# --- 1. Kubernetes 컨텍스트 변경 및 확인 ---
echo "Attempting to switch Kubernetes context to '$CLUSTER_NAME'..."

if ! kubectx "$CLUSTER_NAME"; then
    echo "❌ Error: Failed to switch Kubernetes context to '$CLUSTER_NAME'."
    echo "Please check if 'kubectx' is installed and the context exists before proceeding."
    exit 1
fi

echo "✅ Successfully switched context to '$CLUSTER_NAME'. Starting cleanup process..."
echo "--------------------------------------------------------"


# --- 2. 클러스터 리소스 정리 ---
echo "🚀 Starting EKS cluster cleanup process..."

echo "Step 2-1: Deleting all Ingresses in all namespaces..."
kubectl delete ingress --all --all-namespaces
echo "All Ingresses deleted. Waiting for ALBs to be de-provisioned..."
sleep 60

echo "Step 2-2: Deleting all Services of type LoadBalancer..."
kubectl delete service --field-selector spec.type=LoadBalancer --all --all-namespaces
echo "All LoadBalancer services deleted. Waiting for NLBs to be de-provisioned..."
sleep 60

echo "Step 2-3: Deleting all NodeClaims..."
kubectl delete nodeclaims --all
echo "NodeClaims deleted."

echo "Step 2-4: Deleting all NodePools..."
kubectl delete nodepools --all
echo "NodePools deleted."

echo "Step 2-5: Deleting all EC2NodeClasses..."
kubectl delete ec2nodeclasses --all
echo "EC2NodeClasses deleted."

# --- 3. Terraform 리소스 삭제 ---
echo "Step 3: Running Terraform destroy..."
terraform destroy -auto-approve

echo "✨ EKS cluster cleanup completed."