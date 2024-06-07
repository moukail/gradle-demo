#!/usr/bin/env bash
echo "-------------------------------------------------------------------"
echo "-                create project with gradle                       -"
echo "-------------------------------------------------------------------"
gradle init   --type kotlin-application   --dsl kotlin   --test-framework junit-jupiter   --package nl.moukafih   --project-name my-project    --no-split-project    --java-version 17  <<< 'no'
  
