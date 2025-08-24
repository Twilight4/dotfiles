#!/bin/sh

sensors | awk '/^k10temp/,/^$/' | grep 'Tctl:' | awk '{print $2}'
