#!/bin/bash

echo -e "Deleting the Stack... "

aws cloudformation delete-stack --stack-name $1

aws cloudformation wait stack-delete-complete --stack-name $1

echo "Stacks Deleted along with RDS and EC2 instances..." 
