pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }
    environment {
        aws_access_key_id     = credentials('aws_access_key_id')
        aws_secret_access_key = credentials('aws_secret_access_key')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                script {
                    dir("terraform") {
                        git "https://github.com/Esmailshaikh105/EC2-Pipeline.git"
                    }
                }
            }
        }

        stage('Format') {
            steps {
                sh 'pwd;cd terraform/ ; terraform fmt'
            }
        }

        stage('Validate') {
            steps {
                sh 'pwd;cd terraform/ ; terraform validate'
            }
        }

        stage('Plan') {
            steps {
                sh 'pwd;cd terraform/ ; terraform init'
                sh "pwd;cd terraform/ ; terraform plan -out tfplan"
                sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }

            steps {
                script {
                    def plan = readFile 'terraform/tfplan.txt'
                    def userInput = input message: "Do you want to apply the plan?",
                            parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]

                    if (userInput == 'Yes') {
                        echo "Proceeding with apply"
                    } else {
                        error "Aborted apply as per user input"
                    }
                }
            }
        }

        stage('Apply') {
            steps {
                sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
            }
        }
    }
}

