# aws-wrap

Wrapper around awscli that passes CloudFormation stack outputs to stdout.

```
set -o pipefail ; \
./aws-wrap cloudformation deploy \
  --no-fail-on-empty-changeset \                                                                                                       
  --template-file target/Base.template.yaml \                                                                                
  --stack-name dev-my-project-base \                                                                                                  
  --no-fail-on-empty-changeset \                                                                                                       
  --capabilities CAPABILITY_IAM \                                                                                                      
  --parameter-overrides \                                                                                                              
  ApplicationEnvironment=dev \                                                                                                
| ./aws-wrap cloudformation deploy \                                                                             
  --no-fail-on-empty-changeset \                                                                                                       
  --template-file target/DB.template.yaml \                                                                                  
  --stack-name dev-my-project-db \                                                                                                    
  --no-fail-on-empty-changeset \                                                                                                       
  --parameter-overrides \                                                                                                              
  RDSMasterUserName="postgres" \                                                                                                       
  RDSMasterUserPassword=`ruby -e 'print Regexp.escape File.open(".rds-master-user-password").read'` \                                  
| ./aws-wrap cloudformation deploy \                                                                             
  --no-fail-on-empty-changeset \                                                                                                       
  --template-file target/ElasticBeanstalkApp.template.yaml \                                                                         
  --stack-name dev-my-project-app \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
  KeyPair="dev-my-project" \
  AppDatabaseUserName="application_user" \
  AppDatabaseUserPassword=`ruby -e 'print Regexp.escape File.open(".rds-app-user-password").read'`
  ```
