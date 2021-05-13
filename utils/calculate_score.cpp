#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"
#include <iostream>
#include <string>

using namespace cv;
using namespace std;

std::vector<std::array<double, 4> > calculate_scores(string path) {

  Mat src_base = imread( path );

  if( src_base.empty() )
    {
      cout << "Could not open or find the base image " + path << "\n" << endl;
      exit(-1);
    }

  // HSV Calculation
  Mat hsv_base, hsv_tile;
  cvtColor( src_base, hsv_base, COLOR_BGR2HSV );

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
  Mat hist_base;
  calcHist( &hsv_base, 1, channels, Mat(), hist_base, 2, histSize, ranges, true, false );
  normalize( hist_base, hist_base, 0, 1, NORM_MINMAX, -1, Mat() );

  // Score computation
  std::vector<std::array<double, 4> > vec_scores;
  for(int index_tile = 0; index_tile <= 95; index_tile++)
    {
      string tile_path = "tiles/" + std::to_string(index_tile) + ".jpg";

      Mat hist_tile;
      Mat src_tile = imread( tile_path );

      if( src_tile.empty() )
	{
	  cout << "Could not open or find the tile image " + tile_path << "\n" << endl;
	  exit(-1);
	}

      cvtColor( src_tile, hsv_tile, COLOR_BGR2HSV );
      calcHist( &hsv_tile, 1, channels, Mat(), hist_tile, 2, histSize, ranges, true, false );
      normalize( hist_tile, hist_tile, 0, 1, NORM_MINMAX, -1, Mat() );

      std::array<double, 4> methods_score;
      for( int compare_method = 0; compare_method < 4; compare_method++ )
	{
	  methods_score[compare_method] = compareHist( hist_base, hist_tile, compare_method );
	}
      vec_scores.push_back(methods_score);
    }

  return vec_scores;
}


int main(int argc, char* argv[])
{
  std::vector<std::array<double, 4> > scores = calculate_scores(argv[1]);
  for (std::vector<std::array<double, 4> >::iterator it = scores.begin() ; it != scores.end(); ++it)
    {
      printf("%lf \t %lf \t %lf \t %lf\n", (*it)[0], (*it)[1], (*it)[2], (*it)[3]);
    }
}
