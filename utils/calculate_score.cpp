#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"
#include <iostream>
#include <string>
#include <limits>

using namespace cv;
using namespace std;

Mat img_to_hist(string imgpath)
{
  Mat src = imread( imgpath.c_str() );
  if( src.empty() )
    {
      cout << "Could not open or find the image " + imgpath << "\n" << endl;
      exit(-1);
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

  return hist;
}

std::vector<std::array<double, 4> > calculate_scores(string img_base, string tile_directory, int tile_nb) {
  Mat hist_base = img_to_hist(img_base);

  // Score computation
  std::vector<std::array<double, 4> > vec_scores;
  for(int index_tile = 0; index_tile <= tile_nb; index_tile++)
    {
      string tile_path = tile_directory + "/" + std::to_string(index_tile) + ".jpg";
      Mat hist_tile = img_to_hist(tile_path);

      std::array<double, 4> methods_score;
      for( int compare_method = 0; compare_method < 4; compare_method++ )
	{
	  methods_score[compare_method] = compareHist( hist_base, hist_tile, compare_method );
	}
      vec_scores.push_back(methods_score);
    }

  return vec_scores;
}

int mostFrequent(int arr[], int n)
{
    // Sort the array
    sort(arr, arr + n);

    // find the max frequency using linear traversal
    int max_count = 1, res = arr[0], curr_count = 1;
    for (int i = 1; i < n; i++) {
        if (arr[i] == arr[i - 1])
            curr_count++;
        else {
            if (curr_count > max_count) {
                max_count = curr_count;
                res = arr[i - 1];
            }
            curr_count = 1;
        }
    }

    // If last element is most frequent
    if (curr_count > max_count)
    {
        max_count = curr_count;
        res = arr[n - 1];
    }

    return res;
}

int main(int argc, char* argv[])
{
  string img_base(argv[1]);
  string tile_directory(argv[2]);
  int tile_nb = atoi(argv[3]);

  std::vector<std::array<double, 4> > scores = calculate_scores(img_base, tile_directory, tile_nb);

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
  int matched_index[4] = { -1, -1, -1, -1};
  double best_scores[4] = { numeric_limits<double>::min(), numeric_limits<double>::max(), numeric_limits<double>::min(), numeric_limits<double>::max()};
  for (std::vector<std::array<double, 4> >::iterator it = scores.begin() ; it != scores.end(); ++it)
    {
      if((*it)[0] > best_scores[0])
	{
	  best_scores[0] = (*it)[0];
	  matched_index[0] = index;
        }

      if((*it)[1] <= best_scores[1])
	{
	  best_scores[1] = (*it)[1];
	  matched_index[1] = index;
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
  cout << mostFrequent(matched_index, 4) << "\n";
}
