#!/bin/bash
sudo yum update -y
sudo yum install ruby -y
sudo yum install wget -y

#!/bin/bash
CODEDEPLOY_BIN="/opt/codedeploy-agent/bin/codedeploy-agent"
$CODEDEPLOY_BIN stop
sudp yum erase codedeploy-agent -y

cd /home/ec2-user

wget https://aws-codedeploy-us-west-2.s3.amazonaws.com/latest/install

chmod +x ./install

sudo ./install auto

sudo ./install auto -v releases/codedeploy-agent-###.rpm

sudo service codedeploy-agent status