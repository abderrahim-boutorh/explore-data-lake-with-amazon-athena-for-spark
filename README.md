# Explore Data Lake with Amazon Athena for Spark

## Introduction
In this tutorial, we will learn how we can quickly set up the infrastructure to run an Apache Spark applications on Amazon Athena on AWS Cloud. The primary goal of this tutorial is not to delve into the intricacies of Spark, Python, or SQL, but rather to guide you through the process of creating an environment that seamlessly integrates Apache Spark with Amazon Athena for efficient data exploration in an Amazon S3 data lake.

This tutorial is derived from [this blog](https://www.linkedin.com/pulse/draft/preview/7138492291370913793/) post. Follow the blog to complete the tutorial.

## Prerequisites
For this tutorial, you need the following prerequisites:

- An AWS account to access the AWS Management console.
- An IAM role or user that has the appropriate permissions to access the Athena service (we will guide you through how to add the necessary permissions to your user or role).
- Terraform CLI installed locally - Terraform version `v1.6.5` is used in this tutorial.
- Basic understanding of IAM roles and policies.
- Basic knowledge of PySpark and Python.

## Quick Start
To quickly run this tutorial, run the following commands:

```
cd explore-data-lake-with-amazon-athena-for-spark
terraform init
terraform apply
```