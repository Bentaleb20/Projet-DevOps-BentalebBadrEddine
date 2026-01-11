pipeline {
    agent {
        docker {
            image 'maven:3.8.6-openjdk-17'
            args '-v /root/.m2:/root/.m2'
        }
    }
    
    environment {
        PROJECT_NAME = 'projet-devops'
        SLACK_CHANNEL = '#devops-notifications'
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
                echo 'Compilation de l\'application...'
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
                // Notification Slack optionnelle (si le plugin est installé)
                try {
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
                } catch (Exception e) {
                    echo "Plugin Slack non disponible: ${e.getMessage()}"
                }
            }
        }
        failure {
            echo 'Pipeline échoué !'
            script {
                // Notification Slack optionnelle (si le plugin est installé)
                try {
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
                } catch (Exception e) {
                    echo "Plugin Slack non disponible: ${e.getMessage()}"
                }
            }
        }
        always {
            echo 'Nettoyage...'
            cleanWs()
        }
    }
}
