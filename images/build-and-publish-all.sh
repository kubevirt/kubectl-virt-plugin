#!/bin/bash

images=("builder" "test_install")
for image in "${images[@]}"; do
    ./build.sh $image
    ./publish.sh $image
done