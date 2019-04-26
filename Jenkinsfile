pipeline {
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    disableConcurrentBuilds()
  }
  agent any
  environment {
    IMAGE          = "mariadb-aria"
    TEMP_IMAGE     = "${IMAGE}-build_${BUILD_NUMBER}"
    PUBLIC_LATEST  = "docker.io/jc21/${IMAGE}:latest"
    PRIVATE_LATEST = "docker.jc21.net.au/jcurnow/${IMAGE}:latest"
    // Architectures:
    AMD64_TAG      = "amd64"
  }
  stages {
    stage('Build Master') {
      when {
        branch 'master'
      }
      // ========================
      // amd64
      // ========================
      parallel {
        stage('amd64') {
          agent {
            label 'amd64'
          }
          steps {
            ansiColor('xterm') {
              // Docker Build
              sh 'docker build --pull --no-cache --squash --compress -t ${TEMP_IMAGE}-${AMD64_TAG} .'

              // Dockerhub
              sh 'docker tag ${TEMP_IMAGE}-${AMD64_TAG} ${PUBLIC_LATEST}'
              withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}'"
                sh 'docker push ${PUBLIC_LATEST}'
              }

              // Private
              sh 'docker tag ${TEMP_IMAGE}-${AMD64_TAG} ${PRIVATE_LATEST}'
              withCredentials([usernamePassword(credentialsId: 'jc21-private-registry', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
                sh "docker login -u '${duser}' -p '${dpass}' docker.jc21.net.au"
                sh 'docker push ${PRIVATE_LATEST}'
              }

              sh 'docker rmi ${PUBLIC_LATEST}'
              sh 'docker rmi ${PRIVATE_LATEST}'
              sh 'docker rmi ${TEMP_IMAGE}-${AMD64_TAG}'
            }
          }
        }
      }
    }
  }
  post {
    success {
      juxtapose event: 'success'
      sh 'figlet "SUCCESS"'
    }
    failure {
      juxtapose event: 'failure'
      sh 'figlet "FAILURE"'
    }
  }
}
