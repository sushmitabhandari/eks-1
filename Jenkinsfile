pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {

        stage('terraform started') {
            steps {
                sh 'echo "Started...!" '
            }
        }
        stage('git clone') {
            steps {
                sh 'sudo rm -rf /home/ubuntu/newfolder'
                sh 'sudo rm -rf *;sudo git clone https://github.com/sushmitabhandari/eks-1.git /home/ec2-user/newfolder'
            }
        }
       // stage('tfsvars create') {
         //   steps {
            //    sh 'sudo cp -rf /home/ec2-user/vars.tf /home/ec2-user/newfolder'
          //  }
      //  }
        stage('terraform init') {
            steps {
                sh 'sudo /home/ubuntu/terraform init /home/ubuntu/newfolder'
            }
        }
        stage('terraform plan') {
            steps {
                sh 'sudo ls /home/ubuntu/newfolder; sudo /home/ubuntu/terraform plan /home/ubuntu/newfolder'
            }
        }
        stage('terraform apply') {
            steps {
                sh 'sudo /home/ubuntu/terraform apply --auto-approve /home/ubuntu/newfolder'
            }
        }
        stage('terraform ended') {
            steps {
                sh 'echo "Ended....!!"'
            }
        }

        
    }
}
