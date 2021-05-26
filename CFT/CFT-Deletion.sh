#!/bin/bash

echo -e "Deleting the Stack... "

export AWS_ACCESS_KEY_ID=$ACCESS_KEY && \
export AWS_SECRET_ACCESS_KEY=$SECRET_KEY && \

aws cloudformation delete-stack --stack-name $1

aws cloudformation wait stack-delete-complete --stack-name $1

echo "Stacks Deleted along with RDS and EC2 instances..." 
