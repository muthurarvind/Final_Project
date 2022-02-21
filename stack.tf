provider "aws"{
  region = "us-east-2"
}
resource "aws_cloudformation_stack" "network" {
  name = "networking-stack"

  template_body = <<STACK
AWSTemplateFormatVersion: 2010-09-09
Metadata:
  'AWS::CloudFormation::Designer':
    5a49fac4-991e-4070-916c-5e2a0b1311bd:
      size:
        width: 60
        height: 60
      position:
        x: 198
        'y': 99
      z: 0
      embeds: []
    fef8a509-ced8-430b-81d1-a353eb3cbb59:
      size:
        width: 60
        height: 60
      position:
        x: 315
        'y': 97
      z: 0
      embeds: []
    b943b41c-78a1-4c80-b3ab-ea3c57fca06f:
      size:
        width: 60
        height: 60
      position:
        x: 461
        'y': 104
      z: 0
      embeds: []
    f135fd8f-ac4f-48ab-8ad3-5625d0c5d2ad:
      size:
        width: 60
        height: 60
      position:
        x: 586
        'y': 105
      z: 0
      embeds: []
      dependson:
        - fef8a509-ced8-430b-81d1-a353eb3cbb59
        - b943b41c-78a1-4c80-b3ab-ea3c57fca06f
    355e45e0-9d36-49a7-8d8d-fc3b7f760b9c:
      size:
        width: 60
        height: 60
      position:
        x: 708
        'y': 99
      z: 0
      embeds: []
    1453d6ad-0801-4957-a2f6-c9cc5887b06b:
      size:
        width: 60
        height: 60
      position:
        x: 843
        'y': 100
      z: 0
      embeds: []
      dependson:
        - b943b41c-78a1-4c80-b3ab-ea3c57fca06f
Resources:
  RDSDBI32QQE:
    Type: 'AWS::RDS::DBInstance'
    Properties:
      AllocatedStorage: 10
      Engine: MySQL
      MasterUsername: admin
      MasterUserPassword: ramana4u2021
      DBInstanceClass: db.t2.micro
      DBName: buspassdb
      DBInstanceIdentifier: myrds1
      VPCSecurityGroups:
        - sg-0c51729257f00eea5
      EngineVersion: 5.7
      PubliclyAccessible: true
    Metadata:
      'AWS::CloudFormation::Designer':
        id: 5a49fac4-991e-4070-916c-5e2a0b1311bd
  ELBV2LB1HUDC:
    Type: 'AWS::ElasticLoadBalancingV2::LoadBalancer'
    Properties:
      Name: my-load-balancer
      Subnets:
        - subnet-0311415c865a6e0b9
        - subnet-0729ac5f263db716d
      Type: network
      IpAddressType: ipv4
    Metadata:
      'AWS::CloudFormation::Designer':
        id: fef8a509-ced8-430b-81d1-a353eb3cbb59
  ELBV2TG4A6L0:
    Type: 'AWS::ElasticLoadBalancingV2::TargetGroup'
    Properties:
      Name: my-target-group
      Port: 80
      Protocol: TCP
      VpcId: vpc-030ebc0adf89e5bbf
    Metadata:
      'AWS::CloudFormation::Designer':
        id: b943b41c-78a1-4c80-b3ab-ea3c57fca06f
  ELBV2L42QE:
    Type: 'AWS::ElasticLoadBalancingV2::Listener'
    Properties:
      LoadBalancerArn: !Ref ELBV2LB1HUDC
      Port: 80
      Protocol: TCP
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref ELBV2TG4A6L0
    Metadata:
      'AWS::CloudFormation::Designer':
        id: f135fd8f-ac4f-48ab-8ad3-5625d0c5d2ad
    DependsOn:
      - ELBV2LB1HUDC
      - ELBV2TG4A6L0
  ASLC55LJA:
    Type: AWS::EC2::LaunchTemplate
    Properties: 
      LaunchTemplateName: my-lt
      LaunchTemplateData: 
        IamInstanceProfile:
          Name: demo-Role
        ImageId: ami-0fb653ca2d3203ac1
        InstanceType: t2.micro
        KeyName: keypair1
        SecurityGroupIds:
          - sg-0c51729257f00eea5
        UserData:
          'Fn::Base64': !Sub 
          - |
            #!/bin/bash
            sudo apt-get update -y
            sudo apt-get upgrade -y
            sudo wget https://www.apachefriends.org/xampp-files/8.1.2/xampp-linux-x64-8.1.2-0-installer.run
            sudo chmod 755 xampp-linux-x64-8.1.2-0-installer.run
            sudo ./xampp-linux-x64-8.1.2-0-installer.run
            sudo apt install net-tools
            sudo /opt/lampp/lampp start
            sudo rm -rf /opt/lampp/htdocs/*
            sudo chmod 777 /opt/lampp/htdocs
            sudo git clone https://github.com/muthurarvind/Final_Project.git
            sudo cp -r Final_Project/code/buspassms/* /opt/lampp/htdocs
            sudo chmod 777 /opt/lampp/htdocs/includes/dbconnection.php
            sudo chmod 777 /opt/lampp/htdocs/admin/includes/dbconnection.php
            sudo sed -i.bak 's/localhost/aws_cloudformation_stack.network.template_body.endpoint/g' /opt/lampp/htdocs/includes/dbconnection.php
            sudo sed -i.bak 's/localhost/aws_cloudformation_stack.network.template_body.endpoint/g' /opt/lampp/htdocs/admin/includes/dbconnection.php
            sudo chmod 777 /opt/lampp/etc/extra/httpd-xampp.conf
            sudo sed -i.bak 's/local/all granted/g' /opt/lampp/etc/extra/httpd-xampp.conf
            sudo chmod 755 /opt/lampp/etc/extra/httpd-xampp.conf
            sudo /opt/lampp/lampp restart
            sudo chmod 777 /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["verbose"] = "Amazon RDS";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["host"] = "aws_cloudformation_stack.network.template_body.endpoint";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["user"] = "admin";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["password"] = "ramana4u2021";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["port"] = "3306";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["auth_type"] = "config";' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo echo '$cfg["Servers"][$i]["AllowNoPassword"] = true;' >> /opt/lampp/phpmyadmin/config.inc.php
            sudo chmod 400 /opt/lampp/phpmyadmin/config.inc.php
            sudo /opt/lampp/lampp restart
            sudo apt install mysql-client-core-8.0
            sudo mysql -h ${aws_cloudformation_stack.network.template_body.${!GetAtt RDSDBI32QQE.Endpoint.Address}} -u admin --password=ramana4u2021 buspassdb < /Final_Project/code/SQL\ File/buspassdb.sql
          - endpoint: aws_cloudformation_stack.network.template_body.${!GetAtt RDSDBI32QQE.Endpoint.Address
    Metadata:
      'AWS::CloudFormation::Designer':
        id: 355e45e0-9d36-49a7-8d8d-fc3b7f760b9c
    DependsOn:
      - RDSDBI32QQE
  ASASG3CEB8:
    Type: 'AWS::AutoScaling::AutoScalingGroup'
    Properties:
      AutoScalingGroupName: my-asg1
      LaunchTemplate:
        LaunchTemplateName: my-lt
        Version: !GetAtt ASLC55LJA.LatestVersionNumber
      AvailabilityZones:
        - us-east-2c
      DesiredCapacity: 1
      MaxSize: 2
      MinSize: 1
      TargetGroupARNs:
        - !Ref ELBV2TG4A6L0
    Metadata:
      'AWS::CloudFormation::Designer':
        id: 1453d6ad-0801-4957-a2f6-c9cc5887b06b
    DependsOn:
      - ELBV2TG4A6L0
  ASG2:
    Type: 'AWS::AutoScaling::AutoScalingGroup'
    Properties:
      AutoScalingGroupName: my-asg2
      LaunchTemplate:
        LaunchTemplateName: my-lt
        Version: !GetAtt ASLC55LJA.LatestVersionNumber
      AvailabilityZones:
        - us-east-2c
      DesiredCapacity: 1
      MaxSize: 2
      MinSize: 1
      TargetGroupARNs:
        - !Ref ELBV2TG4A6L0
    Metadata:
      'AWS::CloudFormation::Designer':
        id: 1453d6ad-0801-4957-a2f6-c9cc5887b06b
    DependsOn:
      - ELBV2TG4A6L0
STACK
}
