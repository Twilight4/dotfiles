#!/bin/sh

ffplay -window_title Webcam \
  -f v4l2 \
  -input_format mjpeg \
  -video_size 1920x1080 \
  -framerate 30 \
  -fflags nobuffer \
  -flags low_delay \
  -framedrop \
  /dev/video0
