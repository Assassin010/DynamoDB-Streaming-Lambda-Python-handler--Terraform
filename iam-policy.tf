#Terraform error checking automatically formats your policy document into correct JSON when you run your apply.
#Data sources make it easier to reuse policies throughout your environment. but you can use both.data "" "name" {} in this exmaple i will use iam policys

#I must deploy the policy => aws iam policy and buckets first

resource "aws_iam_policy" "mypolicy" {
  name        = "mypolicy"
  description = "Policy for DynamoDBandS3"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:Describe*",
                "dynamodb:Get*",
                "dynamodb:List*",
                "dynamodb:Batch*",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:Get*",
                "logs:List*",
                "logs:Describe*",
                "logs:PutLogEvents",
                "dynamodb:PutItem",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "sns:CreateTopic",
                "application-autoscaling:Describe*",
                "s3:PutObject",
                "s3:List*",
                "s3:Get*",
                "dynamodb:Scan",
                "tag:Describe*",
                "tag:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


#we can use also data source instead of iam polcy if we want but i will iam policy for this example
#In iam role attachment, policy arn for data source always start with data.aws_iam...arn
/*data "aws_iam_policy_document" "mypolicy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::sourcebucket012/*"]
    effect    = "Allow"
  }
  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::destinationbucket012/*"]
    effect    = "Allow"
  }
}*/


