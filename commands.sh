aws cloudformation create-stack --stack-name AWSDevOpsToolsDemoStack --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --template-body file://pipeline.yml


#codecommit
aws codecommit create-repository --cli-input-json file://./01-demo-codecommit/create-repository.json

git clone https://git-codecommit.us-west-2.amazonaws.com/v1/repos/awsdevops-democodecommit

git clone https://github.com/rdomingo1986/awsdevops-demos-angularbasicapp2021.git

rm -R -f ./awsdevops-demos-angularbasicapp2021/.git

mv ./awsdevops-demos-angularbasicapp2021/* ./awsdevops-democodecommit/

rm -R -f ./awsdevops-demos-angularbasicapp2021/

cd awsdevops-democodecommit

git add .

git commit -m "Initial commit"

git push

#codebuild
aws codebuild create-project --cli-input-json file://../02-demo-codebuild/create-build-project.json

cp ../02-demo-codebuild/buildspec.yml .

git add .

git commit -m "Add buildspec.yml"

git push

aws codebuild start-build --project-name awsdevops-democodebuild

#-

aws s3 cp s3://awsdevops-demoartifacts/awsdevops-democodebuild ../awsdevops-democodebuild.zip

unzip -d ../awsdevops-democodebuild ../awsdevops-democodebuild.zip

cd ../awsdevops-democodebuild/

npm install http-server --global 

http-server .

cd ../awsdevops-democodecommit/

rm -R ../awsdevops-democodebuild/

rm ../awsdevops-democodebuild.zip

#codedeploy
aws deploy create-application --cli-input-json file://../03-demo-codedeploy/create-application.json

aws deploy create-deployment-group --cli-input-json file://../03-demo-codedeploy/create-deployment-group.json

cp ../03-demo-codedeploy/buildspec.yml .

cp ../03-demo-codedeploy/appspec.yml .

mkdir scripts/

cp ../03-demo-codedeploy/scripts/* ./scripts/

git add .

git commit -m "Add appspec.yml and Edit buildspec.yml and Add scripts"

git push

aws codebuild start-build --project-name awsdevops-democodebuild

#--

aws deploy create-deployment --cli-input-json file://../03-demo-codedeploy/create-deployment.json

#codepipeline
#Agregar cambio de color en el archivo
git add .

git commit -m "Change on main file"

git push

aws codepipeline create-pipeline --cli-input-json file://../04-demo-codepipeline/create-pipeline.json

#stage-env
aws codepipeline update-pipeline --cli-input-json file://../05-demo-stage-env/update-pipeline.json

aws deploy create-deployment-group --cli-input-json file://../05-demo-stage-env/create-deployment-group.json

cp ../05-demo-stage-env/buildspec.yml .

cp ../05-demo-stage-env/instancia.yml .

#Agregar cambio de color en el archivo
git add .

git commit -m "Add buildspec.yml and Add instancia.yml + Change"

git push

#--

#manual-approval
aws cloudformation delete-stack --stack-name awsdevops-codedeploydemo-stage-stack

aws codepipeline update-pipeline --cli-input-json file://../06-demo-manualapproval/update-pipeline.json

#Agregar cambio de color en el archivo
git add .

git commit -m "Change"

git push

#--

#Delete
aws codepipeline delete-pipeline --name awsdevops-democodepipeline

aws codecommit delete-repository --repository-name awsdevops-democodecommit

aws codebuild delete-project --name awsdevops-democodebuild

aws deploy delete-application --application-name angular-web-app

cd ..

rm -R -f awsdevops-democodecommit/