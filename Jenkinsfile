pipeline{
    agent any
    tools{
        jdk 'temurinJDK'
        nodejs 'NodeJS'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
    }
    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/EAAZZYY/Amazon-clone.git'
            }
        }
        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Amazon \
                    -Dsonar.projectKey=Amazon '''
                }
            }
        }
        //  stage("quality gate"){
        //    steps {
        //         script {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'jenkins' 
        //         }
        //     } 
        // }
        stage('Install Dependencies') {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withCredentials([usernamePassword(credentialsId: 'docker-login', usernameVariable: 'USER', passwordVariable: 'PASSWORD')]){   
                        sh '''echo "$PASSWORD" | docker login -u "$USER" --password-stdin'''
                        sh "docker build -t eaazzyy/amazon-clone:latest ."
                        sh "docker push eaazzyy/amazon-clone:latest"
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image eaazzyy/amazon-clone:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to container'){
            steps{
                sh 'docker run -d --name amazon-clone -p 3000:3000 eaazzyy/amazon-clone:latest'
            }
        }

        stage("Deploy to Kubernetes cluster") {
            environment {
                AWS_ACCESS_KEY_ID = credentials("jenkins_access_key")
                AWS_SECRET_ACCESS_KEY = credentials("jenkins_secret_access_key")
            }
            steps {
                sh 'kubectl create deployment nginx-deployment --image=nginx'
            }
        }
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
    }
}