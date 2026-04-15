pipeline {
    agent any

    environment {
        JFROG_URL = "https://rohithganisetti.jfrog.io"
        IMAGE_NAME = "javaapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Clone Source Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/rohithganisetti/java-maven-devops-app.git'
            }
        }

        stage('Build Maven Artifact') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Upload Maven Artifact to JFrog') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jfrog-creds',
                    usernameVariable: 'JFROG_USER',
                    passwordVariable: 'JFROG_TOKEN'
                )]) {
                    sh '''
                    curl -f -u $JFROG_USER:$JFROG_TOKEN \
                    -T target/java-maven-app-1.0.jar \
                    https://rohithganisetti.jfrog.io/artifactory/maven-releases/java-maven-app-${BUILD_NUMBER}.jar
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $IMAGE_NAME:$IMAGE_TAG .
                '''
            }
        }

        stage('Push Docker Image to JFrog Docker Repo') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jfrog-creds',
                    usernameVariable: 'JFROG_USER',
                    passwordVariable: 'JFROG_TOKEN'
                )]) {
                    sh '''
                    docker login rohithganisetti.jfrog.io -u $JFROG_USER -p $JFROG_TOKEN
                    docker tag $IMAGE_NAME:$IMAGE_TAG rohithganisetti.jfrog.io/docker-devops/$IMAGE_NAME:$IMAGE_TAG
                    docker push rohithganisetti.jfrog.io/docker-devops/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Pull Selected Docker Image from JFrog') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'jfrog-creds',
                    usernameVariable: 'JFROG_USER',
                    passwordVariable: 'JFROG_TOKEN'
                )]) {
                    sh '''
                    docker login rohithganisetti.jfrog.io -u $JFROG_USER -p $JFROG_TOKEN
                    docker pull rohithganisetti.jfrog.io/docker-devops/$IMAGE_NAME:$IMAGE_TAG
                    '''
                }
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh '''
                docker stop tomcat-container || true
                docker rm tomcat-container || true

                docker run -d --name tomcat-container \
                -p 8082:8080 \
                rohithganisetti.jfrog.io/docker-devops/$IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }
}
