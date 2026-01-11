pipeline {
    agent any
    
    environment {
        PROJECT_NAME = 'projet-devops'
        SLACK_CHANNEL = '#devops-notifications'
        SLACK_CREDENTIALS_ID = 'slack-webhook-url'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                checkout scm
                sh 'git rev-parse HEAD > commit.txt'
                sh 'cat commit.txt'
            }
        }
        
        stage('Build') {
            steps {
                echo 'Compilation et tests de l\'application...'
                sh 'mvn clean compile'
            }
        }
        
        stage('Test') {
            steps {
                echo 'Exécution des tests...'
                sh 'mvn test'
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                    publishTestResults testResultsPattern: 'target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Package') {
            steps {
                echo 'Création du package JAR...'
                sh 'mvn package -DskipTests'
            }
        }
        
        stage('Archive') {
            steps {
                echo 'Archivage des artefacts...'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                archiveArtifacts artifacts: 'commit.txt', fingerprint: true
            }
        }
        
        stage('Deploy') {
            when {
                expression {
                    currentBuild.result == null || currentBuild.result == 'SUCCESS'
                }
            }
            steps {
                echo 'Déploiement de l\'application...'
                script {
                    // Optionnel : déploiement sur serveur local ou cloud
                    sh 'echo "Application déployée avec succès"'
                    sh 'java -jar target/projet-devops-1.0.0.jar || true'
                }
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline exécuté avec succès !'
            script {
                // Notification Slack en cas de succès
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'good',
                    message: """
                        ✅ Pipeline réussi pour ${env.PROJECT_NAME}
                        Build: ${env.BUILD_NUMBER}
                        Auteur: ${env.CHANGE_AUTHOR ?: 'N/A'}
                        Branche: ${env.BRANCH_NAME}
                        Durée: ${currentBuild.durationString}
                    """
                )
            }
        }
        failure {
            echo 'Pipeline échoué !'
            script {
                // Notification Slack en cas d'échec
                slackSend(
                    channel: env.SLACK_CHANNEL,
                    color: 'danger',
                    message: """
                        ❌ Pipeline échoué pour ${env.PROJECT_NAME}
                        Build: ${env.BUILD_NUMBER}
                        Branche: ${env.BRANCH_NAME}
                        Consulter les logs pour plus de détails.
                    """
                )
            }
        }
        always {
            echo 'Nettoyage...'
            cleanWs()
        }
    }
}
