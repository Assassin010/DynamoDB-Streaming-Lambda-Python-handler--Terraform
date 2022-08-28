#DynamoDB Streaming Using Lambda (Python handler) via Terraform


Prerequisites : Code editor (Vscode, Atom, etc), Setup Terraform on your local machine, Setup Terraform in Visual Studio Code, Having an AWS account and an AWS IAM user with the appropriate permissions to perform the necessary actions, Install AWS CLI based on your operating system.

Clone the code to your code editor with git clone command git clone https://github.com/Assassin010/DynamoDB-Streaming-Lambda-Python-handler--Terraform

Deployment Steps: In your terminal Run these commands below (-)

-Terraform init

Initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

-Terraform plan

The terraform plan command lets you to preview the actions Terraform would take to modify your infrastructure, or save a speculative plan which you can apply later.

-Terraform apply-auto-approve To deploy the infra

If you have created the DynamoDB table with any other name, make the changes in code, on line number 6.
same for s3 bucket on line number 23


#Making Changes to the DynamoDB Table and Verifying the Trigger.
We will add new (additional) item to the table but we can also make some changes in the DynamoDB table item that we've created, which will kick off the lambda to deliver a database snapshot to S3. 

But i will create an additional item for this example.

Note: This resource must be deployed as a test for dynamodb trigger => to trigger lambda 
resource "aws_dynamodb_table_item" "item4" 
You can find this info in dynamodb.tf file last block, for this article i will hide it from terraform with hashtag but once you clone this repo, leave as it is with hastag but after deploying the entire infra in first deployment (first apply) if it's successful then come to this additional(item4) to get ride of hashtag but on this iteam and run again terraform apply -auto-apply (as a second deployment)


To verify that, navigate to the S3 and click on the bucket then Select data.txt file and click on Download.

Wait for some time and refresh the page, if you do not see the data.txt file inside the S3 bucket.

Open the data.txt file and verify that the contents of the text file are in the JSON format.

Updated content will be available in the data.txt.

Repeat the procedure of updating and adding new items to the table to see the change reports in S3.


*Streaming cloudwatch logs
Navigate to Cloudwatch.

Click on the Log groups under Logs in the Left Panel.

You should be able to see dynamodb logs under log groups. If it’s not visible, please wait for 5-10 minutes, CloudWatch usually takes around 5-10 minutes after the creation to fetch the details. check the result and more details here: https://bit.ly/3QV6sXi

-To destroy the resources use the command: Terraform destroy-auto-approve
