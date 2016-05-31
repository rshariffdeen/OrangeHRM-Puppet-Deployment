#!/usr/bin/env bash
source ./config
printf "\nInstalling OrangeHRM System\n-----------------------------------------\n\n";
printf "Checking for Puppet Installation....\n";
command -v puppet >/dev/null 2>&1 || {
    printf >&2 "Puppet is not installed.\nInstalling Puppet.....\n";
    /bin/bash ./install_puppet_agent.sh;
    printf "Adding Puppet to your Path\n";
    export PATH=/opt/puppetlabs/bin:$PATH;
    printf "Starting Puppet Service\n";
    service puppet start;
    printf "Finish installing puppet\n\n";
}

printf "Installing Docker module for Puppet\n";
puppet module install garethr-docker

printf "Installing Docker Compose module for Puppet\n";
puppet module install garystafford-docker_compose

printf "Installing Docker via Puppet....\n";
puppet apply PuppetScripts/installDocker.pp

printf "Pulling OrangeHRM docker image...\n";
docker login -u $aws_username -p $aws_token -e none https://285645945015.dkr.ecr.us-east-1.amazonaws.com
docker pull $orangehrm_docker_image

printf "Deploying OrangeHRM System....\n";
puppet apply PuppetScripts/deployOrangeHRM.pp