pipeline {
    agent {
        docker {
        image 'maven:3-jdk-8'
         reuseNode true
         args '--network=maven-demo-net'
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
                sh 'mvn -U -Plocal-docker,jenkins clean install'
            }
        }
        stage('Deploy') {
            input {
                message "Should we deploy?"
                ok "Yes, we should."
            }
            steps {
                sh 'mvn -U -s settings.xml -Plocal-docker,local-deploy,jenkins deploy'
            }
        }
         stage('Release') {
                    input {
                        message "Should we release?"
                        ok "Yes, we should."
                    }
                    steps {

                              withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'jenkins', \
                                                                         keyFileVariable: 'SSH_KEY_FOR_GITHUB')]) {

                              sh ' git config user.email "ci@jenkins.docker.local" && git config user.name "Jenkins CI"'
                              sh 'mvn -U -B -Plocal-docker,local-deploy,jenkins -s settings.xml release:prepare release:perform'
                            }

                     }
                }
    }
}