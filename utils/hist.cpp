#include <iostream>
#include <string>
#include <filesystem>

#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"

using namespace std;
using namespace cv;

int main(int argc, char * argv[]) {
  string filepath = argv[1];
  string output = argv[2];
  Mat src = imread( filepath );

  if( src.empty() )
    {
      cout << "Could not open or find the image\n" << endl;
      return -1;
    }

  // HSV Calculation
  Mat hsv;
  cvtColor( src, hsv, COLOR_BGR2HSV );

  // Histogram parameters
  int h_bins = 50, s_bins = 60;
  int histSize[] = { h_bins, s_bins };
  // hue varies from 0 to 179, saturation from 0 to 255
  float h_ranges[] = { 0, 180 };
  float s_ranges[] = { 0, 256 };
  const float* ranges[] = { h_ranges, s_ranges };
  // Use the 0-th and 1-st channels
  int channels[] = { 0, 1 };

  // Histogram calculation
  Mat hist;
  calcHist( &hsv, 1, channels, Mat(), hist, 2, histSize, ranges, true, false );
  normalize( hist, hist, 0, 1, NORM_MINMAX, -1, Mat() );

  // Save to file
  FileStorage file(output, cv::FileStorage::WRITE);
  file << "h" << hist;
}
