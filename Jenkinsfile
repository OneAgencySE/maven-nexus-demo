pipeline {
    agent {
        docker {
        image 'maven:3-jdk-8'
         reuseNode true
         args '--network=dockerjenkins_default'
        }
    }


    stages {
        stage('Version') {
            steps {
                sh 'mvn --version'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -Plocal-docker,jenkins clean install'
            }
        }
        stage('Deploy') {
            input {
                message "Should we deploy?"
                ok "Yes, we should."
            }
            steps {
                sh 'mvn -s settings.xml -Plocal-docker,local-deploy,jenkins deploy'
            }
        }
         stage('Release') {
                    input {
                        message "Should we release?"
                        ok "Yes, we should."
                    }
                    steps {
                        sshagent (credentials: ['jenkins']) {
                              sh 'mvn -Plocal-docker,local-deploy,jenkins -s settings.xml release:prepare release:perform'
                        }
                    }
                }
    }
}