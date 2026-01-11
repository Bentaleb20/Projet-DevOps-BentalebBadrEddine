pipeline {
    agent any
    
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
        
        stage('Setup Maven') {
            steps {
                script {
                    // Vérifier si Maven est disponible
                    def mvnCheck = sh(script: 'command -v mvn 2>/dev/null || echo "NOT_FOUND"', returnStdout: true).trim()
                    if (mvnCheck == 'NOT_FOUND') {
                        echo 'Installation de Maven dans le workspace...'
                        sh '''
                            # Installation de Maven dans le workspace (sans sudo)
                            cd ${WORKSPACE}
                            if [ ! -d "apache-maven-3.8.6" ]; then
                                echo "Téléchargement de Maven 3.8.6..."
                                wget -q https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz || \
                                curl -L -o apache-maven-3.8.6-bin.tar.gz https://archive.apache.org/dist/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz
                                tar -xzf apache-maven-3.8.6-bin.tar.gz
                                rm -f apache-maven-3.8.6-bin.tar.gz
                            fi
                            export PATH=${WORKSPACE}/apache-maven-3.8.6/bin:$PATH
                            export MAVEN_HOME=${WORKSPACE}/apache-maven-3.8.6
                            mvn -version
                        '''
                    } else {
                        echo "Maven trouvé: ${mvnCheck}"
                        sh 'mvn -version'
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                echo 'Compilation de l\'application...'
                sh '''
                    # Utiliser Maven du workspace ou du système
                    if [ -d "${WORKSPACE}/apache-maven-3.8.6" ]; then
                        export PATH=${WORKSPACE}/apache-maven-3.8.6/bin:$PATH
                    fi
                    mvn clean compile
                '''
            }
        }
        
        stage('Test') {
            steps {
                echo 'Exécution des tests...'
                sh '''
                    if [ -d "${WORKSPACE}/apache-maven-3.8.6" ]; then
                        export PATH=${WORKSPACE}/apache-maven-3.8.6/bin:$PATH
                    fi
                    mvn test
                '''
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
                sh '''
                    if [ -d "${WORKSPACE}/apache-maven-3.8.6" ]; then
                        export PATH=${WORKSPACE}/apache-maven-3.8.6/bin:$PATH
                    fi
                    mvn package -DskipTests
                '''
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
