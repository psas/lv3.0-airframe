#!/bin/bash
find -iname '*.pdf' | awk '{print "["$1"]("$1")  "}'
