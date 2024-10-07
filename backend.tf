#Here, we use an existing s3 bucket as well as dynamodb table to store our state file.
#We are not creating an S3! 


terraform {
    backend "s3" {
        bucket = "my-s3-for-statefile"          #S3 Bucket created
        key = "week7/terraform.tfstate"         #Our state file will be stored in week7 
        region = "us-east-2"
        encrypt = true
        dynamodb_table = "my-locktable"   #This will lock the state file so that only one person can use at the time. 
    }
}

