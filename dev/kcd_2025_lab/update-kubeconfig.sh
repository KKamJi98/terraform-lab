#!/bin/bash

set -euo pipefail

aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-east --alias kkamji-east
aws eks update-kubeconfig --region ap-northeast-2 --name kkamji-west --alias kkamji-west
