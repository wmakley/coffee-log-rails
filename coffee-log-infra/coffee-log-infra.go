package main

import (
	"coffee-log-infra/resources"
	"github.com/aws/aws-cdk-go/awscdk/v2"
	"github.com/aws/aws-cdk-go/awscdk/v2/awscodebuild"
	"github.com/aws/aws-cdk-go/awscdk/v2/awssecretsmanager"

	// "github.com/aws/aws-cdk-go/awscdk/v2/awssqs"
	"github.com/aws/constructs-go/constructs/v10"
	"github.com/aws/jsii-runtime-go"
)

type CoffeeLogInfraStackProps struct {
	awscdk.StackProps
	Resources *resources.CoffeeLogResources
}

func NewCoffeeLogInfraStack(scope constructs.Construct, id string, props *CoffeeLogInfraStackProps) awscdk.Stack {
	var sprops awscdk.StackProps
	if props != nil {
		sprops = props.StackProps
	}
	stack := awscdk.NewStack(scope, &id, &sprops)

	// The code that defines your stack goes here

	//repo := awsecr.NewRepository(stack, jsii.String("AppRepo"), &awsecr.RepositoryProps{
	//	ImageScanOnPush:    jsii.Bool(true),
	//	ImageTagMutability: awsecr.TagMutability_MUTABLE,
	//	RemovalPolicy:      awscdk.RemovalPolicy_DESTROY,
	//	RepositoryName:     jsii.String("coffee-log-rails"),
	//})

	dockerHubSecret := awssecretsmanager.Secret_FromSecretNameV2(stack,
		jsii.String("dockerhub-credentials"),
		jsii.String("dockerhub/credentials"))

	codebuildProject := awscodebuild.NewProject(stack, jsii.String("BuildAppImage"), &awscodebuild.ProjectProps{
		Description: jsii.String("Build coffee log Rails app docker image and push to ECR"),
		Environment: &awscodebuild.BuildEnvironment{
			BuildImage:  awscodebuild.LinuxBuildImage_STANDARD_5_0(),
			ComputeType: awscodebuild.ComputeType_SMALL,
			EnvironmentVariables: &map[string]*awscodebuild.BuildEnvironmentVariable{
				"ECR_REPO_URI": {
					Value: props.Resources.EcrRepo.RepositoryUri(),
				},
			},
			Privileged: jsii.Bool(true),
		},
		BuildSpec: awscodebuild.BuildSpec_FromObjectToYaml(&map[string]interface{}{
			"version": 0.2,
			"env": map[string]interface{}{
				"secrets-manager:": map[string]interface{}{
					"DOCKERHUB_PASS":     "dockerhub/credentials:password",
					"DOCKERHUB_USERNAME": "dockerhub/credentials:username",
				},
			},
			"phases": map[string]interface{}{
				"build": map[string]interface{}{
					"commands": []string{
						"echo Beginning build step at `date`",
						"docker build . -t coffee-log-rails:latest",
						"aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin `echo $ECR_REPO_URI | cut -d/ -f1`",
						"docker tag coffee-log-rails:latest $ECR_REPO_URI:latest",
						"docker push $ECR_REPO_URI:latest",
					},
				},
			},
		}),
		Cache:                awscodebuild.Cache_Local(awscodebuild.LocalCacheMode_DOCKER_LAYER),
		ConcurrentBuildLimit: jsii.Number(1),
		Timeout:              awscdk.Duration_Minutes(jsii.Number(15)),
		Artifacts:            nil,
		Source:               nil,
	})

	dockerHubSecret.GrantRead(codebuildProject, nil)
	props.Resources.EcrRepo.GrantPullPush(codebuildProject)

	// example resource
	// queue := awssqs.NewQueue(stack, jsii.String("CoffeeLogInfraQueue"), &awssqs.QueueProps{
	// 	VisibilityTimeout: awscdk.Duration_Seconds(jsii.Number(300)),
	// })

	return stack
}

func main() {
	defer jsii.Close()

	app := awscdk.NewApp(nil)

	env_ := env()

	_, resources2 := resources.NewCoffeeLogResourcesStack(app, "Resources", &resources.CoffeeLogResourcesStackProps{
		StackProps: awscdk.StackProps{
			Env: env_,
		},
	})

	NewCoffeeLogInfraStack(app, "Infrastructure", &CoffeeLogInfraStackProps{
		StackProps: awscdk.StackProps{
			Env: env_,
		},
		Resources: resources2,
	})

	app.Synth(nil)
}

// env determines the AWS environment (account+region) in which our stack is to
// be deployed. For more information see: https://docs.aws.amazon.com/cdk/latest/guide/environments.html
func env() *awscdk.Environment {
	// If unspecified, this stack will be "environment-agnostic".
	// Account/Region-dependent features and context lookups will not work, but a
	// single synthesized template can be deployed anywhere.
	//---------------------------------------------------------------------------
	return nil

	// Uncomment if you know exactly what account and region you want to deploy
	// the stack to. This is the recommendation for production stacks.
	//---------------------------------------------------------------------------
	// return &awscdk.Environment{
	//  Account: jsii.String("123456789012"),
	//  Region:  jsii.String("us-east-1"),
	// }

	// Uncomment to specialize this stack for the AWS Account and Region that are
	// implied by the current CLI configuration. This is recommended for dev
	// stacks.
	//---------------------------------------------------------------------------
	// return &awscdk.Environment{
	//  Account: jsii.String(os.Getenv("CDK_DEFAULT_ACCOUNT")),
	//  Region:  jsii.String(os.Getenv("CDK_DEFAULT_REGION")),
	// }
}
