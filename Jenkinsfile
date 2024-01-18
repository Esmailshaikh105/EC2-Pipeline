pipeline {
    parameters {
        booleanParam(name: 'autoApprove', defaultValue: false, description: 'Automatically run apply after generating plan?')
    }

    agent any

    stages {
        stage('checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], userRemoteConfigs: [[url: 'git@github.com:Esmailshaikh105/EC2-Pipeline.git']]], credentialsId: 'your-git-credentials-id')
            }
        }

        stage('Plan') {
            steps {
                script {
                    withEnv([
                        "AWS_ACCESS_KEY_ID=${credentials('AWS_ACCESS_KEY_ID')}",
                        "AWS_SECRET_ACCESS_KEY=${credentials('AWS_SECRET_ACCESS_KEY')}"
                    ]) {
                        sh 'pwd;cd terraform/ ; terraform init'
                        sh "pwd;cd terraform/ ; terraform plan -out tfplan"
                        sh 'pwd;cd terraform/ ; terraform show -no-color tfplan > tfplan.txt'
                    }
                }
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
                    withEnv([
                        "AWS_ACCESS_KEY_ID=${credentials('AWS_ACCESS_KEY_ID')}",
                        "AWS_SECRET_ACCESS_KEY=${credentials('AWS_SECRET_ACCESS_KEY')}"
                    ]) {
                        def plan = readFile 'terraform/tfplan.txt'
                        input message: "Do you want to apply the plan?",
                              parameters: [text(name: 'Plan', description: 'Please review the plan', defaultValue: plan)]
                    }
                }
            }
        }

        stage('Apply') {
            steps {
                script {
                    withEnv([
                        "AWS_ACCESS_KEY_ID=${credentials('AWS_ACCESS_KEY_ID')}",
                        "AWS_SECRET_ACCESS_KEY=${credentials('AWS_SECRET_ACCESS_KEY')}"
                    ]) {
                        sh "pwd;cd terraform/ ; terraform apply -input=false tfplan"
                    }
                }
            }
        }
    }
}

