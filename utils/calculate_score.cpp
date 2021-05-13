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

  int index = 0;

  // print scores
  for (std::vector<std::array<double, 4> >::iterator it = scores.begin() ; it != scores.end(); ++it)
    {
      printf("%.2d: %lf \t %lf \t %lf \t %lf\n", index, (*it)[0], (*it)[1], (*it)[2], (*it)[3]);
      index++;
    }

  // Get best score and match tiles
  // https://docs.opencv.org/3.4/d8/dc8/tutorial_histogram_comparison.html
  // For 0 and 2 higher is better
  // For 1 and 3 lesser is better

  index = 0;
  int matched_index[4] = {-1, -1, -1, -1};
  double best_scores[4] = {0, 0, 0, 0};
  for (std::vector<std::array<double, 4> >::iterator it = scores.begin() ; it != scores.end(); ++it)
    {
      printf("%lf < %lf\n", (*it)[1], best_scores[1]);

      if((*it)[0] > best_scores[0])
	{
	  best_scores[0] = (*it)[0];
	  matched_index[0] = index;
        }

      if((*it)[1] <= best_scores[1])
	{
	  best_scores[1] = (*it)[1];
	  matched_index[1] = index;
	  printf("ASSIGNED %d\n", index);
        }


      if((*it)[2] > best_scores[2])
	{
	  best_scores[2] = (*it)[2];
	  matched_index[2] = index;
        }


      if((*it)[3] <= best_scores[3])
	{
	  best_scores[3] = (*it)[3];
	  matched_index[3] = index;
        }

      index++;
    }


  // Print matched index
  printf("Matched tile index: %d %d %d %d\n", matched_index[0], matched_index[1], matched_index[2], matched_index[3]);
}
