# AWS Resources and More

Before I start the next step of this Ramp Up, Carlos and I decided to step aside and start some research about what AWS has to offer, what is commonly used and a few other things that could help me improve my performance in future tasks and overall knowledge.

---

## EC2 (Elastic Computing)*

Tool to launch as many virtual servers as you want without needing to invest in any hardware. It allows you develop and deploy apps.

General purpose, compute optimized, memory optimized, storage optimized, and accelerated computing instance types are available that provide the optimal compute, memory, storage, and networking balance for your workloads.

EC2 allows apps to scale up and down depending on the traffic and demand, which reduces the need to forecast transactions and helps you maintain a clean service to all costumers.

EC2 feats:

- Virtual computing, *instances*.

- Images (AMI's).

- Variety of memory, CPU, storage and network capacity (*instance types*).

- Secure access thanks to *key pairs*.

- Storage volumes for data that gets deleted (*instance store volumes*).

- Persistent storage volumes, *Amazon EBS volumes*.

- Multiple physical locations for the resources to be, *Regions*.

- Firewall to specify protocols, ports, and define sources IP ranges that can access your instances using *security groups*.

- Elastic IPs.

- Create tags for the EC2 resources.

- Virtual Private Clouds (VPC's).

You can specify min/max/desired amount of EC2, and scaling polities.

## S3 (Simple Storage Service)

An object storage service that offers scalability, data availability, security, and performance.

It is a cost-effective and easy-to-use storage service for all kind of apps and any amount of data.

It can be used to:

- Build a data lake (run a big data app like AI, ML, etc.).

- Back up and restore data (RTO, RPO, etc.).

- Archive data at a low cost (S3 Glacier).

- And run cloud-native apps (build mobile, web-based could-native apps).

Data is stored as objects within resources called "buckets" that can be up to 5TB, tagged and the data can move across them.

Flat structure and management feats allow costumers of all sizes to organize their data as they find it most valuable. 

You can group buckets with prefixes and append up to 10 key-value pairs called **S3 object tags** to each bucket.

S3 Batch Operations, you can copy objects between buckets, replace object tag sets, modify access controls, and restore archived objects from S3 Glacier Flexible Retrieval and S3 Glacier Deep Archive storage classes, with a single S3 API request or a few clicks in the S3 console.

You can also use S3 Batch Operations to run AWS Lambda functions across your objects to execute custom business logic, such as processing data or transcoding image files.

Write-once-read-many (WORM) with **S3 Object Lock**: Data can't be modified after created.

S3 Storage Lens gives insight to know what can be improved and can reduce costs.

#### Storage classes

you can store data across a range of different S3 storage classes purpose-built for specific use cases and access patterns:

- S3 Intelligent-Tiering (For data with changing, unknown, or unpredictable access patterns, such as data lakes, analytics, or new applications),

- S3 Standard (For more predictable access patterns, you can store mission-critical production data),

- S3 Standard-Infrequent Access (S3 Standard-IA, for frequent access, save costs by storing infrequently accessed data),

- S3 One Zone-Infrequent Access (S3 One Zone-IA, for frequent access, save costs by storing infrequently accessed data),

- S3 Glacier Instant Retrieval (archive data at the lowest costs in the archival storage classes),

- S3 Glacier Flexible Retrieval (archive data at the lowest costs in the archival storage classes),

- S3 Glacier Deep Archive (archive data at the lowest costs in the archival storage classes),

- and S3 Outposts (If you have data residency requirements that can’t be met by an existing AWS Region).

AWS Lambda is a server-less compute service that runs customer-defined code without requiring management of underlying compute resources.

## RDS (Relational Database Service)*

Amazon RDS handles routine database tasks such as provisioning, patching, backup, recovery, failure detection, and repair.

It provides cost-efficient and resizable capacity while automating time-consuming administration tasks, such as hardware provisioning, database setup, patching, and backups.

Provides you with six familiar database engines to choose from, including Amazon Aurora, PostgreSQL, MySQL, MariaDB, Oracle Database, and SQL Server.

## DynamoDB

A fully managed, server-less, key-value NoSQL database designed to run high-performance applications at any scale. DynamoDB offers built-in security, continuous backups, automated multi-region replication, in-memory caching, and data export tools.

PartiQL is the DDL and DML language.

## ECS (Amazon Elastic Container Service)*

A fully managed container orchestration service that makes it easy for you to deploy, manage, and scale containerized applications.

Deploy the containers you want with the CI/CD and automation tools you prefer.

AWS Fargate: a server-less, pay-as-you-go compute engine that lets you focus on building applications without managing servers. Takes care of all scaling and infrastructure management required.

Docker support, not just Amazon images. Same with containers.

Task definitions are done in JSON.

## ASG (Auto Scaling Groups)*

An ASG contains a collection of Amazon EC2 instances that are treated as a logical grouping for the purposes of automatic scaling and management.

An ASG starts by launching enough instances to meet its desired capacity. If an instance becomes unhealthy, the group terminates the unhealthy instance and launches another instance to replace it.

An Auto Scaling group can launch On-Demand Instances, Spot Instances, or both.

## ELB (Elastic Load Balancer)*

Automatically distributes incoming application traffic across multiple targets and virtual appliances in one or more Availability Zones (AZs).

Different types of Load Balancers, look up with one is better suited for the project.

It allows health checks to be done to EC2's, containers, IP's, microservices, Lambda functions and appliances.

## - ALB (Application Load Balancer)

Operates at the request level [layer 7 (OSI Model): load balance HTTP/HTTPS traffic to targets - EC2, microservices, containers based on the request content]. Simplifies and improves the security of your application, by ensuring that the latest SSL/TLS ciphers and protocols are used at all times.

## VPC (Virtual Private Cloud)*

Your virtual networking environment, including resource placement, connectivity, and security.

## EIP (Elastic IP)*

A *static* IPv4 address, reachable from the internet, designed for dynamic cloud computing. Mask a failure of an instance by remapping the address to another instance.

## Subnets* (public or private)

Subnets are a logical partition of an IP network into multiple, smaller network segments.

One goal of a subnet is to split a large network into a grouping of smaller, interconnected networks to help minimize traffic. This way, traffic doesn't have to flow through unnecessary routers, increasing network speeds.

## DNS (Domain Name System)

The phonebook of the Internet. DNS translates domain names to IP addresses so browsers can load Internet resources.

## Route 53*

A highly available and scalable cloud Domain Name System (DNS) web service.

## NAT (Network Address Translation) Gateway *

Connect instances in a private subnet can connect to services outside the VPC but external services cannot initiate a connection with those instances

Public: Default, you route traffic from the NAT gateway to the internet gateway for the VPC.

Private: Instances in a private subnet can connect to other instances in other VPC.

## IGW (Internet Gateway)

Logical connection between an AWS VPC to the internet. It allows resources within your VPC to access the internet, and vice versa. In order for this to happen, there needs to be a routing table entry allowing a subnet to access the IGW.
