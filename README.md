# codename-wings

This project will allow you to **automatically**: 

* deploy a Go web server application with built in Prometheus exporter and basic routing functionality. 
* deploy the app to Kubernetes cluster on AWS EKS using Terraform.
* using Terraform deploy Prometheus server on AWS EC2 instance and make all changes necessary for Ansible run.
* run Ansible play which will configure Prometheus to add Go web server app's metrics to be scraped.

## golang-server-webapp

Dockerized Golang based server web application. Starts HTTP server on port 8080 with web app
that has built-in Prometheus exporter and basic routing functionality, i.e:

* Displays which links are available: http://wings.hodzic.org
* Displays picture of Homer Simpson: http://wings.hodzic.org/homersimpson
* Displays current time in Amsterdam and in Covilha, Portugal: http://wings.hodzic.org/covilha

Total number of HTTP requests for links above will be available as following queries in Prometheus:

* [http_requests_total](http://prometheus.hodzic.org:9090/graph?g0.range_input=1h&g0.expr=http_requests_total%7Bjob%3D%22golang-server-webapp%22%7D&g0.tab=1)
* [http_requests_total_homersimpson](http://prometheus.hodzic.org:9090/graph?g0.range_input=1h&g0.expr=http_requests_total_homersimpson&g0.tab=1)
* [http_requests_total_covilha](http://prometheus.hodzic.org:9090/graph?g0.range_input=1h&g0.expr=http_requests_total_covilha&g0.tab=1)


### Golang run example:

```
cd gofiles/; go run main.go
```

### Docker image build & publish using Makefile example:

```
make v=0.1
```

### Docker run example:

```
docker run -d -p 80:8080 docker.io/adnanhodzic/golang-server-webapp:0.1
```

## terraform-k8s-aws-eks-deploy

Collection of Terraform configuration files which allow you to seamlessly and automatically deploy Kubernetes cluster on Amazon EKS. Allowing you to easily deploy [Go server WebApp](https://github.com/AdnanHodzic/codename-wings#golang-server-webapp).

### Setup necessary tools

#### AWS credentials config

Pre-requisite is to have AWS key credentials with admin permissions.

To keep sync of any AWS key credential changes made to `~/.aws/config/` file:
```
ln -s ~/.aws/config ~/.aws/credentials
```

or to take a snapshot of current AWS key credentials in `~/.aws/config/` file:
```
cp ~/.aws/config ~/.aws/credentials
```

#### Install Kubectl

Command line interface for running commands against Kubernetes clusters. 

MacOs:
```
brew install aws-iam-authenticator
```

Ubuntu:
```
sudo snap install kubectl --classic
```

#### Install aws-iam-authenticator

A tool to use AWS IAM credentials to authenticate to a Kubernetes cluster on AWS EKS.

MacOS/Ubuntu:

```
wget https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/tag/0.4.0-alpha.1
chmod +x aws-iam-authenticator_0.4.0-alpha.1_darwin_amd64
sudo mv aws-iam-authenticator_0.4.0-alpha.1_darwin_amd64 /usr/local/bin/heptio-authenticator-aws
heptio-authenticator-aws help
```

### Deploy Kubernetes cluster to AWS EKS

Create `terraform.tfvars` file where you'll store your AWS credential keys. This file is set to ignore by `.gitignore` so don't worry about pushing your AWS key credentians to Github. Example contents, i.e:

```
AWS_ACCESS_KEY = "SECRET"
AWS_SECRET_KEY = "SECRET"
AWS_REGION = "eu-west-1"
```

To initialize a working directory (no need to run every time) containing Terraform configuration files, run:

```
terraform init
```

To see execution plan or refresh of stack if changes are made:

```
terraform plan
```

Run to deploy Kubernetes cluster on Amazon EKS.

```
terraform apply
```

Once everything is successfuly deployed you need to configure kubectl (will overwrite existing config):

```
terraform output kubeconfig > ~/.kube/config
```

Configure config-map-aws-auth:

```
terraform output config-map-aws-auth > config-map-aws-auth.yml
kubectl apply -f config-map-aws-auth.yml
```

Verify that everything is working as expected and that you nodes that can communicate to cluster:

```
kubectl get nodes --watch
```

Once all nodes are in `Ready` state, proceed to next step.

### Deploy Go server WebApp to Kubernetes cluster on Amazon EKS

Deploy [golang-server-webapp](https://github.com/AdnanHodzic/codename-wings#golang-server-webapp) Docker image to be running on internal port: 8080

```
kubectl run go-server-webapp --image=docker.io/adnanhodzic/golang-server-webapp:0.1 --port=8080
```

Check the deployment state:

```
kubectl get deployments
kubectl get pods
```

Deploy loadbalancer to which we can connect publically on port 80, after which we're redirected to internal port 8080:

```
kubectl expose deployment go-server-webapp --type=LoadBalancer --port 80 --target-port 8080
```

Check state of our loadbalancer:

```
kubectl get services
```

Get full informaton about loadbalancer (and its A record):

```
kubectl describe services go-server-webapp
```

Update DNS records of your domain with values of `LoadBalancer Ingress` line which has our loadbalancer A record, i.e:
```
LoadBalancer Ingress:     a467d5230fb2311e8bfef0adf1c7b2a4-385229931.eu-west-1.elb.amazonaws.com
```

After this, in my case [golang-server-webapp](https://foolcontrol.org/wp-content/uploads/2018/12/wings-root.png) will now be running on http://wings.hodzic.org

![alt text](https://foolcontrol.org/wp-content/uploads/2018/12/wings-index.png)

### Decomission Kubernetes cluster from AWS EKS

Kuberenetes cluster and all its resources will be removed by running:

```
terraform destroy
```

## terraform-ansible-prometheus-deploy

Collection of Terraform configuration files which deploy AWS EC2 instance and performing necessary tasks for it to be SSH-able out of box. `hosts` file will also be automatically pouplated with its public IP, after which this hosts file can be use as an inventory file to run Ansible. Once Ansible is ran it will install Prometheus and configure it to scrap metrics from [golang-server-webapp](https://github.com/AdnanHodzic/codename-wings#golang-server-webapp).

### Deploy Prometheus server

#### Server deployment with Terraform

Make sure `terraform.tfvars` exists in this directory with same contents as in [Deploy Kubernetes cluster to AWS EKS](https://github.com/AdnanHodzic/codename-wings#deploy-kubernetes-cluster-to-aws-eks) section. 

If this file is present, proceed by running: 

```
terraform init
```

To deploy AWS EC2 instance which will be used as Prometheus server, and make all necessary infrastructal changes run:

```
terraform apply
```

After server is deployed, up and running you'll get following message:

```
Apply complete! Resources: 5 added, 0 changed, 0 destroyed.

Outputs:

ip = 54.171.81.213
```

This same IP has been automatically added to `hosts` file which makes it ready to run Anisble to install and configure Prometheus.

Update DNS records of your domain with this IP, in my case I do this for http://prometheus.hodzic.org record.

#### Install and configure Prometheus with Ansible

**Ansible run pre-requisites**

In case you don't have Ansible installed, install by running:

Mac:
```
brew install ansible
```

Ubuntu:
```
apt install ansible
```

You'll have to [import your SSH key pair using AWS Console](https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#KeyPairs:sort=keyName). Make sure to update `ssh_key_name` variable in `vars.tf` file with your imported key pair name. Currently this value is set to: `id_rsa_hodzic`.

Reason why this is done manually, instead of [aws_key_pair import](https://www.terraform.io/docs/providers/aws/r/key_pair.html) is because Terraform fails at importing SSH key size of 4096 bits. At the time of writing this, maximum supported key strengh is 2048 bits.

You'll also have to install [adnanhodzic.python-ubuntu-bootstrap](https://galaxy.ansible.com/AdnanHodzic/python-ubuntu-bootstrap) role, which can be done by running:

```
ansible-galaxy install adnanhodzic.python-ubuntu-bootstrap
```

**run Ansible**

Run Ansible with following command:

```
ansible-playbook prometheus.yml -i hosts -b -u ubuntu
```

After Ansible play has finished, Prometheus will be up and running.

If you updated your DNS record as suggested in [Server deployment with Terraform](https://github.com/AdnanHodzic/codename-wings#server-deployment-with-terraform) Prometheus will be accessible from your domain on port 9090, in my case: http://prometheus.hodzic.org:9090/

After which you'll be able to find our [golang-server-webapp](https://github.com/AdnanHodzic/codename-wings#golang-server-webapp) pre-configured as one of our targets ready to be scraped.

![alt text](https://foolcontrol.org/wp-content/uploads/2018/12/prometheus-targets.png)

![alt text](https://foolcontrol.org/wp-content/uploads/2018/12/http-request-total-query.png)

![alt text](https://foolcontrol.org/wp-content/uploads/2018/12/prometheus-all-metrics.png)


#### Decomission Prometheus server

Prometheus server and all its resources will be removed by running:

```
terraform destroy
```
