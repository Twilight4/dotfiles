#!/bin/bash

UPDATE=$(checkupdates | wc -l)

if [ ${UPDATE} -lt 1 ]; then
  echo ""
else
  echo "<span font='12' rise='1000'></span> ${UPDATE}"
fi
