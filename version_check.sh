#!/bin/bash

MC_VER=$(curl -s -H "accept-language:*" -H "User-Agent: Mozilla/5.0" https://www.minecraft.net/en-us/download/server/bedrock | grep serverBedrockLinux | grep -o -P '(?<=bedrock-server-).*(?=.zip)')
CUR_VER=$(docker run ghcr.io/jsandas/minecraft-bedrock:latest cat version)


if [[ "{{ env.MC_VER }}" != "{{ env.CUR_VER }}" ]]; then 
    sed -i 's/MC_VER=.*/MC_VER={{ env.MC_VER }}/g' Dockerfile
fi
      
git diff --no-ext-diff --quiet --exit-code
if [[ $? -eq 1 ]]; then
git config --global user.name "jsandas"
git config --global user.email "jsandas@users.noreply.github.com"

git add -A
git commit -m "update mc version to {{ env.MC_VER}}"
git push
fi