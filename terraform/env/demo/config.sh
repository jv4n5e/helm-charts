#!/bin/bash

export ENV="scalegrid-demo"
export REGION=af-south-1
export EKS_CLUSTER_NAME=eks-cluster-$ENV
#export AWS_PROFILE=<AWS_PROFILE>
export INTERNAL_IP_RANGE="10.0.0.0/16"
export TERRAFORM_BUCKET_NAME="scalegrid-bucket"

# Create bucket
aws s3api create-bucket \
     --bucket $TERRAFORM_BUCKET_NAME \
     --region $REGION \
     --create-bucket-configuration LocationConstraint=$REGION

# Make it not public     
aws s3api put-public-access-block \
    --bucket $TERRAFORM_BUCKET_NAME \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

# Enable versioning
aws s3api put-bucket-versioning \
    --bucket $TERRAFORM_BUCKET_NAME \
    --versioning-configuration Status=Enabled

terraform init \
    -backend-config="bucket=$TERRAFORM_BUCKET_NAME" \
    -backend-config="key=$ENV/terraform-state" \
    -backend-config="region=$REGION" \
    ../../plan/ 

terraform apply ../../plan/ 