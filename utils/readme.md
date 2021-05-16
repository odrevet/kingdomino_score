# Utils using OpenCV

sudo apt install libopencv-dev

## Create histogram

To preload the app the pre-calculated histogram

  g++ hist.cpp `pkg-config --cflags --libs opencv4` -o hist
  for tile in ./tiles/*; do ./hist $tile "${tile%.*}.json"; done

## Calculate score

To test which method to use for histogram compare
Will compare and print scores of base_image with every jpg from 0 to tile_nb in tile_directory
Arguments : base_image tile_directory tile_nb

* build
  g++ calculate_score.cpp `pkg-config --cflags --libs opencv4` -o calculate_score


* usage example

  ./calculate_score input/camera/30.jpg input/scan 23

# Split to tiles

Tiles are created from scan or phone camera as input for tests.

A picture can be split into tiles using image magic convert:

  convert input/camera_0.jpg -crop 438x367 %02d.jpg