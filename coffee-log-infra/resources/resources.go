package resources

import (
	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/aws/aws-cdk-go/awscdk/v2/awsecr"
	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
)

type CoffeeLogResourcesStackProps struct {
	awscdk.StackProps
}

type CoffeeLogResources struct {
	EcrRepo awsecr.IRepository
}

func NewCoffeeLogResourcesStack(scope constructs.Construct, id string, props *CoffeeLogResourcesStackProps) (awscdk.Stack, *CoffeeLogResources) {
	var sprops awscdk.StackProps
	if props != nil {
		sprops = props.StackProps
	}
	stack := awscdk.NewStack(scope, &id, &sprops)

	resources := &CoffeeLogResources{
		EcrRepo: awsecr.NewRepository(stack, jsii.String("AppRepo"), &awsecr.RepositoryProps{
			ImageScanOnPush:    jsii.Bool(true),
			ImageTagMutability: awsecr.TagMutability_MUTABLE,
			RemovalPolicy:      awscdk.RemovalPolicy_DESTROY,
			RepositoryName:     jsii.String("coffee-log-rails"),
		}),
	}

	return stack, resources
}
