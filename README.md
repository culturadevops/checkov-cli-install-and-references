# checkov-cli-install-and-references
checkov command, checkov install, examples references



[![video mini tutorial](https://i.ytimg.com/vi/t5Dx7Qx3MwE/hqdefault.jpg?sqp=-oaymwEXCNACELwBSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLDPKl4nLpOIyVpgsETLsunUi9s8cg)](https://youtu.be/t5Dx7Qx3MwE)


# Command install 

    pip install checkov

## Instalacion de checkov en centos 
    yum install python
    yum install pip
    sudo yum remove python3-requests
    pip install checkov

## Instalacion de checkov en linux ubuntu
    sudo apt update 
    sudo apt install pip3
    sudo pip3 install checkov
    export PATH=$PATH:/home/ubuntu/.local/bin/



# para skip en checkov para casi todos los framework
#checkov:skip=CKV_DOCKER_2:The bucket is a public static content host



# fix
https://github.com/bridgecrewio/checkov/issues/2863
