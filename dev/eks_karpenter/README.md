# EKS Cluster with Karpenter

## How to Delete EKS Cluster

Follow these steps in order to properly delete an EKS cluster with Karpenter:

1. Delete all NodeClaims
   ```bash
   kubectl delete nodeclaims --all
   ```

2. Delete all NodePools
   ```bash
   kubectl delete nodepools --all
   ```

3. Delete all EC2NodeClasses
   ```bash
   kubectl delete ec2nodeclasses --all
   ```

4. Run Terraform destroy
   ```bash
   terraform destroy -auto-approve
   ```

## Cleanup Script

For convenience, you can use the `destroy.sh` script in this directory to perform all the cleanup steps in the correct order.

```bash
# Run the cleanup script
./destroy.sh
```
