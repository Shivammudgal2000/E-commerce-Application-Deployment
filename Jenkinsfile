pipeline {
    agent any
    
    // Environment variables for the pipeline
    environment {
        // Your specific Docker Hub repository
        DOCKER_REPO = 'shivammudgal/elite-java-app'
        
        // This automatically tags each new image with the Jenkins Build Number (e.g., v1, v2, v3)
        APP_VERSION = "v${env.BUILD_ID}" 
    }

    stages {
        stage('Git Checkout') {
            steps {
                // Tells Jenkins to pull the latest code from GitHub
                checkout scm
                echo "Source code fetched successfully."
            }
        }

        stage('Maven Build') {
            steps {
                echo "Compiling Java Code and building WAR file..."
                // Automates the build step you did earlier
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                echo "Building Docker Image: ${DOCKER_REPO}:${APP_VERSION}"
                // Automates the multi-stage Docker build
                sh "docker build -t ${DOCKER_REPO}:${APP_VERSION} ."
                // Simultaneously tags the new build as the 'latest' production version
                sh "docker tag ${DOCKER_REPO}:${APP_VERSION} ${DOCKER_REPO}:latest"
            }
        }

        stage('Docker Push') {
            steps {
                echo "Pushing new images to Docker Hub..."
                // Uses Jenkins secure credentials to login and push
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', passwordVariable: 'DOCKER_PASS', usernameVariable: 'DOCKER_USER')]) {
                    sh "echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin"
                    sh "docker push ${DOCKER_REPO}:${APP_VERSION}"
                    sh "docker push ${DOCKER_REPO}:latest"
                }
            }
        }
    }
}
