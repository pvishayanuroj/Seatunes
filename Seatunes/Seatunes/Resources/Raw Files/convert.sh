#!/bin/bash
for f in *.wav; do
	afconvert -f caff -d LEI16@44100 -c 1 "$f" 
done
