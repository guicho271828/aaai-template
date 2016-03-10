#!/bin/bash

echo -n "word count: $(sed 's/-/ /g' $1 | wc -w)"
