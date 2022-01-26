# !/bin/bash

# makefileで配列やifを書くのは面倒なのでシェルスクリプトに記述

CONTAINER_NAME=$1
DOCKER_HOME_DIR=$2

if [[ -z ${CONTAINER_NAME} || -z ${DOCKER_HOME_DIR} ]]; then

	echo
    echo "[ERROR] $LINENO"
    echo "引数が指定されていません"
    echo
    exit 1

fi

# rescue_code_path=($(find ~/ -maxdepth 4 -type d -name ".*" -prune -o -type f -print | grep config/module.cfg | sed 's@/config/module.cfg@@g'))
docker container cp ../src/ ${CONTAINER_NAME}:${DOCKER_HOME_DIR}/
docker container cp ../include/ ${CONTAINER_NAME}:${DOCKER_HOME_DIR}/
docker container cp src/ ${CONTAINER_NAME}:${DOCKER_HOME_DIR}/test/
docker container cp include/ ${CONTAINER_NAME}:${DOCKER_HOME_DIR}/test/

rescue_code_path=($(find ../include/ -maxdepth 4 -type f -name "*.cpp"))
code_path=($(find ../include/ -maxdepth 4 -type d -name "src"))
if [[ ${#code_path[@]} -gt 0 ]]; then

	for item in "${code_path[@]}" ; do

		docker container cp ${item} ${CONTAINER_NAME}:${DOCKER_HOME_DIR}/src/

	done

fi
rescue_code_path=($(find test/src/ -maxdepth 4 -type f -name "*.cpp"))

if [[ ${#rescue_code_path[@]} -gt 0 ]]; then

	for item in "${rescue_code_path[@]}" ; do

		docker container cp ${item} ${CONTAINER_NAME}:${DOCKER_HOME_DIR}

	done

else

    echo
    echo "[ERROR] $LINENO"
    echo "レスキューのソースコードを発見できませんでした"
    echo
    exit 1

fi