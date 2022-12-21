# How to manage multiple environments with terraform workspaces?

### What is Terraform?

Terraform is a free and open-source infrastructure as code (IAC) that can help to automate the deployment, configuration, and management of the remote servers. Terraform can manage both existing service providers and custom in-house solutions.

![1](https://github.com/DhruvinSoni30/Terraform_Multiple_Environments/blob/main/images/terraform.jpeg)

### What is Terraform Workspaces?

Workspaces in the Terraform CLI refer to separate instances of state data inside the same Terraform working directory. They are distinctly different from workspaces in Terraform Cloud, which each have their own Terraform configuration and function as separate working directories. Using workspaces you can manage different environments easily!

![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/6.png)

### Step1:

* Create `main.tf` file and add below code in it
  
  ```
  provider "aws" {
    region = var.region
  }
  resource "aws_instance" "example" {
    ami           = var.ami
    instance_type = var.size
    tags = {
      Name = "demo-server"
    } 
  }
  ```
  
* Create `variales.tf` file and add below code in it

  ```
  variable "region" {
    default = "us-east-2"
  }
 
  variable "ami" {
    default = "ami-0a606d8395a538502"
  }

  variable "size" {
    default = "t2.micro"
  }
  ```

* The above code will create en EC2 instance in AWS 

### Step 2:

* Now, we will create terraform workspace calledd `stg` using below command

  ```
  terraform workspace new stg
  ```

* Run below commands in the `stg` workspace and it will create an EC2 instance

  ```
  terraform init
  terraform plan
  terraform apply
  ```

### Step 3:

* Now, we will create terraform workspace calledd `dev` using below command

  ```
  terraform workspace new dev
  ```

* Run below commands in the `dev` workspace and it will create an EC2 instance

  ```
  terraform init
  terraform plan
  terraform apply
  ```

Even though there is one instance already up & running on AWS, terraform will create one more instance because we run the terraform commands from different workspace!


### Step 4:

* Now, we will create terraform workspace calledd `prod` using below command

  ```
  terraform workspace new prod
  ```

* Run below commands in the `prod` workspace and it will create an EC2 instance

  ```
  terraform init
  terraform plan
  terraform apply
  ```

* Now, you will see total 3 EC2 instances up & running on AWS

![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/1.png)

In the above image you can see that we have same name for all 3 servers and to overcome that we can modify our `main.tf` file as per below

 ```
  provider "aws" {
    region = var.region
  }
  resource "aws_instance" "example" {
    ami           = var.ami
    instance_type = var.size
    tags = {
      Name = "example-server-${terraform.workspace}"
    } 
  }
  ```

* The above code will create server name like below

  ```
  demo-server-stg
  demo-server-dev
  demo-server-prod
  ```
![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/2.png)


* We can use different size of instance for different environment also, for that we need to modify our `main.tf` file as below

  ```
  provider "aws" {
    region = var.region
  }

  locals {
    instance_types = {
      dev   = "t2.micro"
      stg = "t2.small"
      prod  = "m4.large"
    }
  }

  resource "aws_instance" "demo_server" {
    ami           = var.ami
    instance_type = local.instance_types[terraform.workspace]
    tags = {
      Name = "example-server-${terraform.workspace}"
    }
  }
  ```
  
![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/2.png)

* In the above image you can see different size for instances

* We can also store state file for all the workspaces in S3 also, and for that create `backend.tf` file and add below code in it

  ```
  terraform {
  backend "s3" {
    bucket = "dhsoni-tf"
    region = "us-east-2"
    key    = "terraform.tfstate"
  }
  }
  ```

* Note:- I have already created the bucket called `dhsoni-tf` on S3

* Run `terraform init` again & the above code will create `env:` folder and inside that it will create 3 folders i.e `stg`, `prod` & `dev` and store state file in it!


![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/3.png)

![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/4.png)

![2](https://github.com/DhruvinSoni30/Terraform_Wrokspaces/blob/main/images/5.png)

