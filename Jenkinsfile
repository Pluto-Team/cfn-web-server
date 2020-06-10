pipeline {
    agent any
    // only keeps track of 5 builds at once
     options {
        buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '5'))
    }

    stages {
        stage ("Starting Build") {
            steps{
                slackSend (color: '#FFFF00', message: "@channel STARTED Web Server CloudFormation lint checker: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
            }
        }

        stage( "Lint and push template to S3" ) {
            steps {
                catchError {
                    sh 'chmod +x push-to-s3.ps1'
                    sh "pwsh push-to-s3.ps1 ${env.BRANCH_NAME}"
                }
            }

            post {
                success {
                        slackSend (color: '#00FF00', message: "No errors found in linting! '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
                }
                failure{
                    slackSend (color: '#FF0000', message: "Errors found in linting! Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
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
            slackSend (color: '#00FF00', message: "@channel Job finished with a SUCCESSFUL status: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
        }

        failure {
            slackSend (color: '#FF0000', message: "@channel Job finished with a FAILED status: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")

            
        }

    } // end of post


} // end of pipeline