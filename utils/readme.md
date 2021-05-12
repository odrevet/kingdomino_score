# Create histogram

  sudo apt install libopencv-dev
  g++ hist.cpp `pkg-config --cflags --libs opencv4` -o hist
  for tile in ./img/*; do ./hist $tile "${tile%.*}.json"; done
