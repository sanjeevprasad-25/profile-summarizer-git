pipeline {
    agent any

    environment {
        docker_credential = "sanjeevprasad1983"
        docker_image = "${docker_credential}/git-profile-summary"
        version_name = "${BUILD_NUMBER}.0"
        MAX_REPOS = "5"
    }

    stages {

        stage("Clone") {
            steps {
                echo "Cloning started"

                git branch: "main",
                url: "https://github.com/sanjeevprasad-25/profile-summarizer-git.git"

                echo "Cloning successful"
            }
        }

        stage("Docker Build") {
            steps {
                echo "Building Docker image"

                withCredentials([string(credentialsId: 'github-token-secret', variable: 'GITHUB_TOKEN_VALUE')]) {

                    bat """
                    docker build -t ${docker_image}:${version_name} ^
                    --build-arg VITE_GITHUB_TOKEN=${GITHUB_TOKEN_VALUE} ^
                    --build-arg VITE_MAX_REPOS=${MAX_REPOS} .
                    """
                }

                echo "Docker build successful"
            }
        }

        stage("Login and Push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'Dockeruser', usernameVariable: 'dockeruser', passwordVariable: 'dockerpass')]) {

                    bat "echo %dockerpass% | docker login -u %dockeruser% --password-stdin"
                    bat "docker push ${docker_image}:${version_name}"
                }
            }
        }

        stage("Deployment") {
            steps {
                bat "docker rm -f git-profile-summary || exit 0"
                bat "docker run -d -p 5050:80 --name git-profile-summary ${docker_image}:${version_name}"
            }
        }
    }

    post {
        always {
            echo "Pipeline finished"
        }

        success {
            echo "Build successful"
        }

        failure {
            echo "Build failed"
        }
    }
}