all: kubectl-image jenkins-inbound-agent-image

kubectl-image:
	docker build -t gdisdevops/kubectl:local -f kubectl/Dockerfile .

jenkins-inbound-agent-image:
	docker build -t gdisdevops/jenkins-inbound-agent:local -f jenkins-inbound-agent/Dockerfile .
