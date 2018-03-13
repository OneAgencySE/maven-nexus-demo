pipeline {
    agent {
        docker { image 'maven:3-jdk-8' }
    }
    stages {
        stage('Version') {
            steps {
                sh 'mvn --version'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn -Plocal-docker clean install'
            }
        }
        stage('Deploy') {
            input {
                message "Should we deploy?"
                ok "Yes, we should."
            }
            steps {
                sh 'mvn -s settings.xml -Plocal-docker,local-deploy deploy'
            }
        }
    }
}