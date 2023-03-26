pipeline {
    
  agent any

stages {
    
  stage ('terraform create instance') {   
    steps {
      sh '''
      terraform init
      terraform providers lock -net-mirror=https://terraform-mirror.yandexcloud.net -platform=linux_amd64 yandex-cloud/yandex
      terraform plan
      terraform apply --auto-approve
      sleep 60
      ansible-playbook provisioning.yaml
      '''
    }
  }
  
  stage ('build app & push to registry') {
      steps {
          sh 'ansible-playbook buildapp.yaml'
      }
  }
   
  stage ('pull from registry & deploy app') {
      steps {
          sh 'ansible-playbook deployapp.yaml'
      }
  } 
 }  
}