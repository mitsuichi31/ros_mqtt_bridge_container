USER_NAME=mitz
WORKSPACE=devel

xhost local:
docker run --rm -it --privileged \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /etc/localtime:/etc/localtime \
        -v /home/$USER_NAME/$WORKSPACE:/$USER_NAME/$WORKSPACE \
        -v /home/$USER_NAME/docker:/$USER_NAME/docker \
        -e DISPLAY=$DISPLAY \
        -e SIM=true \
        -e MOVEIT=true \
        -e NAVI=true \
        --network host \
        --name ubuntu2404docker \
        ubuntu2404docker:mqtt-bridge
