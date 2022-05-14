package main

import (
	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/aws/aws-cdk-go/awscdk/v2/awss3"
	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
)

type AwsStackProps struct {
	awscdk.StackProps
}

func NewAwsStack(scope constructs.Construct, id string, props *AwsStackProps) awscdk.Stack {
	var sprops awscdk.StackProps
	if props != nil {
		sprops = props.StackProps
	}
	stack := awscdk.NewStack(scope, &id, &sprops)

	bucketID := jsii.String("dev.toddtee.sh")

	bucket := awss3.NewBucket(stack, bucketID, &awss3.BucketProps{
		BucketName:           bucketID,
		PublicReadAccess:     jsii.Bool(true),
		Versioned:            jsii.Bool(false),
		WebsiteIndexDocument: jsii.String("index.html"),
	})

	UNUSED(bucket)

	return stack
}

func UNUSED(x ...interface{}) {}

func main() {
	app := awscdk.NewApp(nil)

	NewAwsStack(app, *jsii.String("static-toddtee-development"), &AwsStackProps{
		awscdk.StackProps{
			Synthesizer: awscdk.NewDefaultStackSynthesizer(&awscdk.DefaultStackSynthesizerProps{
				FileAssetsBucketName: jsii.String("teamturner-aws-cdk"),
			}),
			Env: env(),
		},
	})

	app.Synth(nil)

}

// env determines the AWS environment (account+region) in which our stack is to be deployed.
func env() *awscdk.Environment {
	return &awscdk.Environment{
		Account: awscdk.Aws_ACCOUNT_ID(),
		Region:  jsii.String("ap-southeast-2"),
	}
}
