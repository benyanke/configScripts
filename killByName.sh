#!/bin/bash

name=$1

sudo kill $(ps aux | grep '$name' | awk '{print $2}')
