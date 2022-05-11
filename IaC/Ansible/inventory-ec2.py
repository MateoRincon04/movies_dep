import boto3

ec2 = boto3.resource('ec2')
instances = ec2.instances.filter(
    Filters=[{'Name': 'tag:project', 'Values': ['ramp-up-devops']}, {'Name': 'tag:responsible', 'Values': ['mateo.rincona']}, {'Name': 'tag:Name', 'Values': ['Backend-movie-analyst', 'Frontend-movie-analyst']}])
for instance in instances:
    print(instance.id, instance.instance_type)

with open('name', 'w') as file:
    file.write('abcd')
