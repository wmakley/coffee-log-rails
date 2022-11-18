package main

import (
	"coffee-log-infra/resources"
	"testing"

	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/aws/aws-cdk-go/awscdk/v2/assertions"
	"github.com/aws/jsii-runtime-go"
)

func TestCoffeeLogInfraStack(t *testing.T) {
	// GIVEN
	app := awscdk.NewApp(nil)

	// WHEN
	_, resources2 := resources.NewCoffeeLogResourcesStack(app, "ResourcesStack", nil)
	stack := NewCoffeeLogInfraStack(app, "MyStack", &CoffeeLogInfraStackProps{
		Resources: resources2,
	})

	// THEN
	template := assertions.Template_FromStack(stack, nil)

	template.HasResourceProperties(jsii.String("AWS::CodeBuild::Project"), map[string]interface{}{
		"TimeoutInMinutes": 15,
	})
}
