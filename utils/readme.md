# Utils using OpenCV

sudo apt install libopencv-dev

# Create histogram

To preload the app the pre-calculated histogram

  g++ hist.cpp `pkg-config --cflags --libs opencv4` -o hist
  for tile in ./tiles/*; do ./hist $tile "${tile%.*}.json"; done

# Calculate score

To test which methof to use for histogram compare


  g++ calculate_score.cpp `pkg-config --cflags --libs opencv4` -o calculate_score
  ./calculate_score camera_01.jpg