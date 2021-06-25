sh ~/environment/init/resize.sh 60
sudo yum -y install jq gettext bash-completion moreutils

aws iam create-user --user-name sbuser
aws iam attach-user-policy --user-name sbuser --policy-arn arn:aws:iam::aws:policy/AdministratorAccess
aws iam create-access-key --user-name sbuser
read YOUR_ACCESS_KEY YOUR_SECRET_ACCESS_KEY < <(echo $(aws iam create-access-key --user-name sbuser | jq -r '.AccessKey.AccessKeyId, .AccessKey.SecretAccessKey'))

rm -vf ${HOME}/.aws/credentials


echo '[default]' >> ~/.aws/credentials
echo 'aws_access_key_id = '$YOUR_ACCESS_KEY >> ~/.aws/credentials
echo 'aws_secret_access_key = '$YOUR_SECRET_ACCESS_KEY >> ~/.aws/credentials
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
aws configure set default.region ${AWS_REGION}




mkdir ~/environment/setup && cd ~/environment/setup
wget https://mirror.navercorp.com/apache/maven/maven-3/3.8.1/binaries/apache-maven-3.8.1-bin.tar.gz
tar xzvf apache-maven-3.8.1-bin.tar.gz
export PATH=/home/ec2-user/environment/apache-maven-3.8.1/bin:$PATH
mvn --version

nvm install 14.15.1
node --version

npm install --global yarn
yarn --version

curl -o AWSApp2Container-installer-linux.tar.gz https://app2container-release-us-east-1.s3.us-east-1.amazonaws.com/latest/linux/AWSApp2Container-installer-linux.tar.gz
sudo tar xvf AWSApp2Container-installer-linux.tar.gz
sudo ~/environment/setup/install.sh
