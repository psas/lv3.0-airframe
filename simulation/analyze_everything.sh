#!/bin/bash
echo simData/*.csv | xargs -n 1 ./analysis.R
./compileReductions.R
