pipeline {
    agent {
        node {
            label 'master'
        }
    }

    stages {
         stage('install terraform') {
            steps {
		    sh 'sudo mkdir /home/ubuntu/newfolder'
	          sh 'sudo cd /home/ubuntu/newfolder'
	          sh 'sudo wget https://releases.hashicorp.com/terraform/0.12.23/terraform_0.12.23_linux_amd64.zip'
                  sh 'sudo apt-get install unzip -y'
	          echo 'unzip installed'
                  sh 'sudo unzip terraform_0.12.23_linux_amd64.zip'
	          sh  'sudo cp ./terraform /usr/bin/terraform && export PATH=$PATH:/usr/bin'
	          sh 'terraform --version'
		      echo 'terraform done'  
		    		}
        	}
			stage('install kubectl') {
            steps {
              sh  'sudo curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl'
	       	  sh  'sudo curl -o kubectl.sha256 https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/kubectl.sha256'
              sh  'sudo openssl sha1 -sha256 kubectl'
              sh  'sudo chmod +x ./kubectl'
              sh  'sudo cp ./kubectl /usr/bin/kubectl && export PATH=$PATH:/usr/bin'
              sh  'echo "export PATH=$PATH:/usr/bin" >> ~/.bashrc'
	          //sh  'echo "export PATH=$PATH:/usr/bin" >> ~/.bash_profile'
	          sh  'sudo -s source ~/.bashrc'
	      //sh  'source ~/.bash_profile'
              sh  'sudo kubectl version --short --client'
              sh  'sudo rm -rf ~/.kube && sudo mkdir ~/.kube'                                 
              sh  'sudo touch ~/.kube/config-eks'
              echo 'kubectl done'
		    		}
        	}
			stage('install iam-auth') {
            steps {
              sh  'sudo curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator'
	          sh  'sudo chmod +x ./aws-iam-authenticator'
	          sh  'sudo cp ./aws-iam-authenticator /usr/bin/aws-iam-authenticator && export PATH=$PATH:/usr/bin'
	          echo 'iam done'
	          sh 'aws-iam-authenticator version'
	 			   }
		}

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
