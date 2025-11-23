# list all available subcommands
_default:
  @just --list

# create-stack
create:
  aws cloudformation create-stack \
    --stack-name MyStack \
    --region ap-southeast-1 \
    --template-body file://cloudformation/s3.yaml \
    --parameters ParameterKey=BucketName,ParameterValue=demo-7725746233776973

# describe-stacks
describe:
  aws cloudformation describe-stacks \
    --stack-name MyStack \
    --region ap-southeast-1 \

# describe-stack-events
events:
  aws cloudformation describe-stack-events \
    --stack-name MyStack \
    --region ap-southeast-1 \

# update-stack
update:
  aws cloudformation update-stack \
    --stack-name MyStack \
    --region ap-southeast-1 \
    --template-body file://cloudformation/s3.yaml \
    --parameters ParameterKey=BucketName,ParameterValue=demo-7725746233776973

# delete-stack
delete:
  aws cloudformation delete-stack \
    --region ap-southeast-1 \
    --stack-name MyStack
  aws cloudformation wait stack-delete-complete \
    --region ap-southeast-1 \
    --stack-name MyStack

# detect-stack-drift
drift:
  aws cloudformation detect-stack-drift \
    --region ap-southeast-1 \
    --stack-name MyStack

# validate-template
validate:
  aws cloudformation validate-template \
    --region ap-southeast-1 \
    --template-body file://cloudformation/s3.yaml \
