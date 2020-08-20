pipeline {
    agent any
    // only keeps track of 5 builds at once
     options {
        buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '5'))
    }

    stages {
        stage ("Starting Build") {
            steps{
                office365ConnectorSend  message: "STARTED Web Server CloudFormation lint checker: ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}", status: "Success", webhookUrl: env.TEAMS_WEBOOK_URL
            }
        }

        /* stage ("Import python modules") {
            steps{
                sh 'python3 -m pip install cfn-lint --user'
            }
        } */ 

        stage( "Lint and push template to S3" ) {
            steps {
                catchError {
                    sh 'chmod +x push-to-s3.ps1'
                    sh "pwsh push-to-s3.ps1 ${env.BRANCH_NAME}"
                }
            }

            post {
                success {
                        office365ConnectorSend  message: "No errors found in linting! ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}", status: "Success", webhookUrl: env.TEAMS_WEBOOK_URL
                        
                }
                failure{
                    office365ConnectorSend  message: "Errors found in linting! ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}", status: "Failed", webhookUrl: env.TEAMS_WEBOOK_URL
                }
            }
        }

        // clean up the workspace
       stage( "Clean Up" ) {
            steps {
                sh 'rm -rf *'
            }
        }
    }

    // after completing all of the stage tasks above, it will send an email if there was failure or success
    post {
        success {
            office365ConnectorSend  message: "Job finished with a SUCCESSFUL status: Job ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}", status: "Success", webhookUrl: env.TEAMS_WEBOOK_URL
        }

        failure {
            office365ConnectorSend  message: "Job finished with a FAILED status: Job ${env.JOB_NAME} ${env.BUILD_NUMBER} ${env.BUILD_URL}", status: "Failed", webhookUrl: env.TEAMS_WEBOOK_URL

            
        }

    } // end of post


} // end of pipeline