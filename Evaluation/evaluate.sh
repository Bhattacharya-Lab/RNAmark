#!/bin/bash

input="TS72.txt"
toolname=$1

rm Score.csv

while IFS= read -r line
do

    PDBID=$line
    
    #====================================================
    nativepath="../Data/Natives"
    predpath="../Predictions/WithMSA"
    
    path=""

    native="Native/"$PDBID"_native.pdb"
    prediction="Prediction/"$PDBID"_$toolname.pdb"

    rm Native/*
    rm Prediction/*
    rm -rf runs/default/*

    rm -rf pdbs/models
    rm -rf pdbs/references

    mkdir -p pdbs/models
    mkdir -p pdbs/references
    
    cp $nativepath/$PDBID"_native.pdb" $native
    cp $predpath/$PDBID/$PDBID"_$toolname.pdb" $prediction

    cp $nativepath/$PDBID"_native.pdb" pdbs/references
    cp $predpath/$PDBID/$PDBID"_$toolname.pdb" pdbs/models

    #TM-score calculation
    #====================================================
    USalign_path="PUT USalign PATH HERE" #Change

    $USalign_path./USalign $prediction $native > TMlog.txt

    #Clash score calculation
    #====================================================
    oneline-analysis Prediction > clashlog.txt

    #INF-All calculation
    #====================================================
    #Please change this path to your installed directory
    inf_path="/home/RNA/casp-rna/run_parallel.py" #Change, PUT casp-rna path here

    python3 $inf_path pdbs inf

    rm -rf figures
    rm -rf scores

    #lDDT calculation
    #====================================================
    
    echo "#!/bin/bash" > cmd.sh
    echo "" >> cmd.sh

    echo "podman run --rm --security-opt label=disable -v $path/Native:/ref -v $path/Prediction:/mod -v $path/Output:/out -it openstructure:latest compare-structures --reference /ref/$PDBID"_native.pdb" --model /mod/$PDBID"_"$toolname".pdb" --output /out/output.json --lddt --lddt-no-stereochecks &" >> cmd.sh

    echo ""

    echo "wait" >> "cmd.sh"

    chmod a+x cmd.sh
    ./cmd.sh
    
    #Parse all the metrics
    #====================================================
    python3 parse.py $PDBID

done < "$input"
