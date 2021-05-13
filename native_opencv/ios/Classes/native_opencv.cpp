#include "opencv2/imgcodecs.hpp"
#include "opencv2/imgproc.hpp"
#include <iostream>
#include <string>

#ifdef __ANDROID__
#include <android/log.h>
#endif

using namespace cv;
using namespace std;

long long int get_now() {
    return chrono::duration_cast<std::chrono::milliseconds>(
            chrono::system_clock::now().time_since_epoch()
    ).count();
}

void platform_log(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);
#ifdef __ANDROID__
    __android_log_vprint(ANDROID_LOG_VERBOSE, "ndk", fmt, args);
#else
    vprintf(fmt, args);
#endif
    va_end(args);
}

// Avoiding name mangling
extern "C" {
    // Attributes to prevent 'unused' function from being removed and to make it visible
    __attribute__((visibility("default"))) __attribute__((used))
    const char* version() {
        return CV_VERSION;
    }

    __attribute__((visibility("default"))) __attribute__((used))
    int process_image(char* path) {

        Mat src_base = imread( path );

        if( src_base.empty() )
        {
            cout << "Could not open or find the image\n" << endl;
            return -1;
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
        double score_max = 0;
        int index_tile;
        int index_tile_max_score = 0;
        for(index_tile = 0; index_tile <= 95; index_tile++)
        {
            //TODO pre-calculate hist to file
            string tile_path = "/data/data/fr.odrevet.kingdomino_score_count/app_flutter/" + std::to_string(index_tile) + ".jpg";

            Mat hist_tile;
            Mat src_tile = imread( tile_path );

            if( src_tile.empty() )
            {
                cout << "Could not open or find the image\n" << endl;
                return -1;
            }

            cvtColor( src_tile, hsv_tile, COLOR_BGR2HSV );
            calcHist( &hsv_tile, 1, channels, Mat(), hist_tile, 2, histSize, ranges, true, false );
            normalize( hist_tile, hist_tile, 0, 1, NORM_MINMAX, -1, Mat() );

            double score =  compareHist( hist_base, hist_tile, 0 );
            platform_log("READ FILE: %s SCORE: %lf\n", tile_path.c_str());
            if(score > score_max)
            {
                score_max = score;
                index_tile_max_score = index_tile;
            }
        }

         return index_tile_max_score;
    }
}
