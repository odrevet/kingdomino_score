# Utils using OpenCV

sudo apt install libopencv-dev

## Create histogram

To preload the app the pre-calculated histogram

  g++ hist.cpp `pkg-config --cflags --libs opencv4` -o hist
  for tile in ./tiles/*; do ./hist $tile "${tile%.*}.json"; done

## Calculate score

To test which method to use for histogram compare


  g++ calculate_score.cpp `pkg-config --cflags --libs opencv4` -o calculate_score
  ./calculate_score camera_01.jpg


# Split to tiles

A picture can be split into tiles using image magic

  convert input/camera_0.jpg -crop 438x367 %02d.jpg