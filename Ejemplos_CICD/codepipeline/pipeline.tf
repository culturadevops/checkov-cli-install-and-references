resource "aws_codebuild_project" "plan" {
  name          = "cicd-plan"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.assume_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "public.ecr.aws/ackstorm/checkov:latest"
    type                        = "LINUX_CONTAINER"
     image_pull_credentials_type = "CODEBUILD"
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/plan-buildspec.yml")
 }
}

resource "aws_codebuild_project" "apply" {
  name          = "cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.assume_codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "public.ecr.aws/hashicorp/terraform:1.6.5"
    type                        = "LINUX_CONTAINER"
     image_pull_credentials_type = "CODEBUILD"

 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("buildspec/apply-buildspec.yml")
 }
}


resource "aws_codepipeline" "cicd_pipeline" {

    name = "terraform-deploy"
    role_arn = aws_iam_role.assume_codepipeline_role.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts.id
    }

        stage {
            name = "Source"
            action{
                name = "Source"
                category = "Source"
                owner = "AWS"
                provider = "CodeStarSourceConnection"
                version = "1"
                output_artifacts = ["code"]
                configuration = {
                    FullRepositoryId = "culturadevops/checkov-cli-install-and-references"
                    BranchName   = "master"
                    ConnectionArn =aws_codestarconnections_connection.example.arn
                    OutputArtifactFormat = "CODE_ZIP"
                }
            }
        }

    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["code"]
            configuration = {
                ProjectName = "cicd-plan"
            }
        }
    }

    stage {
        name ="Deploy"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["code"]
            configuration = {
                ProjectName = "cicd-apply"
            }
        }
    }

}