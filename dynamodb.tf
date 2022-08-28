resource "aws_dynamodb_table" "congo-dynamodb-table" {
  name             = "congo"
  billing_mode     = "PROVISIONED"
  read_capacity    = 20
  write_capacity   = 20
  hash_key         = "id"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  tags = {
    Name        = "congo-dynamodb-table"
    Environment = "test"
  }

  attribute {
    name = "id"
    type = "S"
  }
}
################################################################################################################################################################################
#The are different ways of creating items. this one is the easiest one but imagine that you have multiple iteams like 15? it doesnt make sence to create them one after another.
#We can create just one dynamodb table item block and use the following Meta-Arguments: count or for_each
#In this article i will "for_each" but just right below i can show how create it with using multiple dynamdb blocks.
/*resource "aws_dynamodb_table_item" "item1" {
  table_name = aws_dynamodb_table.congo-dynamodb-table.name
  hash_key   = aws_dynamodb_table.congo-dynamodb-table.hash_key

  item = <<ITEM
{
  "Id": {"S": "12"},
  "firstName": {"S": "Josepth"},
  "lastName ": {"S": "Kabila"},
  "age": {"S": "51"}
}
ITEM
}


resource "aws_dynamodb_table_item" "item2" {
  table_name = aws_dynamodb_table.congo-dynamodb-table.name
  hash_key   = aws_dynamodb_table.congo-dynamodb-table.hash_key

  item = <<ITEM
{
  "Id": {"S": "13"},
  "firstName": {"S": "Moise"},
  "lastName": {"S": "Katumbi"},
  "age": {"S": "57"}
}
ITEM
}



resource "aws_dynamodb_table_item" "item3" {
  table_name = aws_dynamodb_table.congo-dynamodb-table.name
  hash_key   = aws_dynamodb_table.congo-dynamodb-table.hash_key

  item = <<ITEM
{
  "Id": {"S": "14"},
  "fistName": {"S": "Vital"},
  "lastName": {"S": "Kamerhe"},
  "age": {"S": "63"}
}
ITEM
}*/
################################################################################################################################################################################

#This how the structure will look like if you want to use the Meta-Argument "Count" 
/*resource "aws_dynamodb_table_item" "items" {
  count = 4
  item <<EOF
{
  "pk": {"S": "${count.index}"}
}
EOF
}*/


######################################################################################################################################
#Let me jump to my choice using "for_each" Meta-Argument
resource "aws_dynamodb_table_item" "items" {
  table_name = aws_dynamodb_table.congo-dynamodb-table.name
  hash_key   = "id"
  depends_on = [
    aws_dynamodb_table.congo-dynamodb-table
  ]
  for_each = {
    "item1" = {
      id       = "12"
      firstName = "Joseph"
      lastName = "Kabila"
      age      = "51"
    }

    "item2" = {
      id       = "13"
      firstName = "Moise"
      lastName = "Katumbi"
      age      = "57"
    }

    "item3" = {
      id       = "14"
      firstName = "Vital"
      lastName = "Kamerhe"
      age      = "63"
    }

#########################################################################################################
#Making Changes to the DynamoDB Table and Verifying the Trigger.
#We will make some changes in the DynamoDB table that we've created, which will kick off the lambda to deliver a database snapshot to S3.
#To do that let's create an additional item in the same table. (item4)

/*"item4" = {
      id       = "15"
      firstName = "JeanPierre"
      lastName = "Mbemba"
      age      = "60"
    }*/


  }
  item = <<ITEM
{
  "id": {"S": "${each.key}"},
  "firstName": {"S": "${each.value.firstName}"},
  "lastName": {"S": "${each.value.lastName}"},
  "age": {"S": ${jsonencode(each.value.age)}}
}
ITEM
}

#Adding Triggers to the DynamoDB Table
#trigger lambda function from DynamoDB
resource "aws_lambda_event_source_mapping" "allow_dynamodb_table_to_trigger_lambda" {
  event_source_arn  = aws_dynamodb_table.congo-dynamodb-table.stream_arn
  function_name     = aws_lambda_function.congo_dynamodb_function.arn
  batch_size        = 1
  enabled           = true
  starting_position = "LATEST"
  depends_on = [
    aws_dynamodb_table.congo-dynamodb-table
  ]
}

