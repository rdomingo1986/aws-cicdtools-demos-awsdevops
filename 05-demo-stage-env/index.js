var AWS = require('aws-sdk');

var sns = new AWS.SNS();

var codepipeline = new AWS.CodePipeline();

exports.handler = (event, context, callback) => {
  var jobId = event["CodePipeline.job"].id;
  console.log(jobId);
  sns.publish({
    TopicArn: 'arn:aws:sns:${AWS::Region}:${AWS::AccountId}:awsdevops-demonotifications',
    Message: 'Se ha iniciado una compilación \n' + JSON.stringify(event),
    Subject: 'Building in process'
  }, function (err, response) {
    if (err) {
      codepipeline.putJobFailResult({ jobId: jobId }, function(err, data) {
        if(err) {
            context.fail(err);      
        } else {
            context.succeed(data);      
        }
      });
      return console.log(err);
    }
    codepipeline.putJobSuccessResult({ jobId: jobId }, function(err, data) {
        if(err) {
            context.fail(err);      
        } else {
            context.succeed(data);      
        }
    });
    console.log(response);
  });
}; 