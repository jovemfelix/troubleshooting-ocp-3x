#!/bin/bash

THIS_SCRIPT=$(basename -- "$0")
echo Executando $THIS_SCRIPT

# Explorar status dos nodes
tail nodes <> not Ready
tail pods <> not Running| Completed
tail event
