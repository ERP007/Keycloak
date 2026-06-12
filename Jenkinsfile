pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    environment {
        SERVER_HOST = 'taehyung@host.docker.internal'
        SERVER_BASE = '/home/taehyung/apps/msa-server'
        SERVICE_DIR = 'keycloak'
        COMPOSE_PROJECT = 'erp007-keycloak'
        HEALTH_URL = 'https://auth.erp007.xyz/realms/master/.well-known/openid-configuration'
    }

    stages {
        stage('Deploy') {
            steps {
                sshagent(credentials: ['erp007-server-ssh']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${SERVER_HOST} '
                            set -eu
                            cd ${SERVER_BASE}/${SERVICE_DIR}
                            git pull --ff-only origin main

                            docker compose -f docker-compose.yml -p ${COMPOSE_PROJECT} config >/tmp/erp007-keycloak-compose.yml
                            docker compose -f docker-compose.yml -p ${COMPOSE_PROJECT} up -d --build --remove-orphans
                        '
                    """
                }
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                    set -eu
                    for attempt in $(seq 1 30); do
                        if curl -fsS --max-time 10 "$HEALTH_URL" >/dev/null; then
                            exit 0
                        fi
                        sleep 3
                    done
                    curl -fsS --max-time 10 "$HEALTH_URL" >/dev/null
                '''
            }
        }
    }
}
