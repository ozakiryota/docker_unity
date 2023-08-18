#!/bin/bash

xhost +

image="unity_editor"
tag="latest"
exec_pwd=$(cd $(dirname $0); pwd)
home_dir="/home/user"

docker run \
	-it \
	--rm \
	-e local_uid=$(id -u $USER) \
	-e local_gid=$(id -g $USER) \
	-e "DISPLAY" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
	--privileged \
	--gpus all \
	-v $exec_pwd/mount/Project:$home_dir/Unity/Project \
	$image:$tag \
	bash -c "unityhub"