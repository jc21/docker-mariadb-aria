pipeline {
	agent {
		label 'docker-multiarch'
	}
	options {
		buildDiscarder(logRotator(numToKeepStr: '5'))
		disableConcurrentBuilds()
		ansiColor('xterm')
	}
	environment {
		IMAGE           = 'mariadb-aria'
		BRANCH_LOWER    = "${BRANCH_NAME.toLowerCase().replaceAll('/', '-')}"
		BUILDX_NAME     = "${COMPOSE_PROJECT_NAME}"
		MARIADB_VERSION = '10.4.15'
	}
	stages {
		stage ("lint dockerfile") {
			agent {
				docker {
					image 'hadolint/hadolint:latest-debian'
					label 'docker'
				}
			}
			steps {
				sh 'hadolint Dockerfile* | tee -a hadolint.txt'
			}
			post {
				always {
					archiveArtifacts 'hadolint.txt'
				}
			}
		}
		stage('Environment') {
			parallel {
				stage('Master') {
					when {
						branch 'master'
					}
					steps {
						script {
							env.BUILDX_PUSH_TAGS = "-t docker.io/jc21/${IMAGE}:latest -t docker.io/jc21/${IMAGE}:${MARIADB_VERSION}"
						}
					}
				}
				stage('Other') {
					when {
						not {
							branch 'master'
						}
					}
					steps {
						script {
							// Defaults to the Branch name, which is applies to all branches AND pr's
							env.BUILDX_PUSH_TAGS = "-t docker.io/jc21/${IMAGE}:github-${BRANCH_LOWER}"
						}
					}
				}
			}
		}
		stage('MultiArch Build') {
			when {
				not {
					equals expected: 'UNSTABLE', actual: currentBuild.result
				}
			}
			steps {
				withCredentials([usernamePassword(credentialsId: 'jc21-dockerhub', passwordVariable: 'dpass', usernameVariable: 'duser')]) {
					sh "docker login -u '${duser}' -p '${dpass}'"
					sh "./scripts/buildx --push ${BUILDX_PUSH_TAGS}"
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
