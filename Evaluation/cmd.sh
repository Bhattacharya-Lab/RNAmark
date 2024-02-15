#!/bin/bash

podman run --rm --security-opt label=disable -v Native:/ref -v Prediction:/mod -v Output:/out -it openstructure:latest compare-structures --reference /ref/6YMC_A_native.pdb --model /mod/6YMC_A_DeepFoldRNA.pdb --output /out/output.json --lddt --lddt-no-stereochecks &
wait
