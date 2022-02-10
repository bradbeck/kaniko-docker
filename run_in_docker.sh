#!/bin/bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://github.com/GoogleContainerTools/kaniko/blob/main/run_in_docker.sh

set -e

version="v1.5.1"

if [ $# -lt 3 ]; then
    echo "Usage: run_in_docker.sh <path to Dockerfile> <context directory> <image tag> <cache>"
    exit 1
fi

dockerfile=$1
context=$2
destination=$3

cache="false"
if [[ ! -z "$4" ]]; then
    cache=$4
fi

if [[ $destination == *"gcr"* ]]; then
    if [[ ! -e $HOME/.config/gcloud/application_default_credentials.json ]]; then
        echo "Application Default Credentials do not exist. Run [gcloud auth application-default login] to configure them"
        exit 1
    fi
    docker run \
        -v "$HOME"/.config/gcloud:/root/.config/gcloud \
        -v "$context":/workspace \
        gcr.io/kaniko-project/executor:"$version" \
        --dockerfile "${dockerfile}" --destination "${destination}" --context dir:///workspace/ \
        --cache="${cache}"
else
    docker run \
        -v "$context":/workspace \
        gcr.io/kaniko-project/executor:"$version" \
        --dockerfile "${dockerfile}" \
        --destination "${destination}" \
        --context dir:///workspace/ \
        --digest-file /workspace/digest-file \
        --cache="${cache}"
fi
