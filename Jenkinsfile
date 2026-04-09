pipeline {
  agent any

  environment {
    IMAGE_NAME = "smart-hostel"
    IMAGE_TAG = "${env.BUILD_NUMBER}"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install Dependencies') {
      steps {
        sh '''
          python3 -m venv .venv
          . .venv/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt
        '''
      }
    }

    stage('Lint and Test') {
      steps {
        sh '''
          . .venv/bin/activate
          ruff check tests db.py
          pytest -q
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
      }
    }

    stage('Trivy Scan') {
      steps {
        sh '''
          trivy image --severity HIGH,CRITICAL --exit-code 0 $IMAGE_NAME:$IMAGE_TAG || true
        '''
      }
    }

    stage('Deploy (Optional)') {
      when {
        branch 'main'
      }
      steps {
        echo 'Hook this stage to Ansible or kubectl apply for deployment.'
      }
    }
  }
}
