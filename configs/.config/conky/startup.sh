#!/bin/bash

sleep 60s
killall conky
conky -b -c ~/.config/conky/.conkyrc 
