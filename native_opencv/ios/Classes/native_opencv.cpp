#include "opencv2/imgcodecs.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <iostream>

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
    double process_image(String path1, String path2) {
        Mat src_base = imread( path1 );
        Mat src_test1 = imread( path2 );

        if( src_base.empty() || src_test1.empty() )
        {
            cout << "Could not open or find the images!\n" << endl;
            return -1;
        }

        Mat hsv_base, hsv_test1;
        cvtColor( src_base, hsv_base, COLOR_BGR2HSV );
        cvtColor( src_test1, hsv_test1, COLOR_BGR2HSV );

        int h_bins = 50, s_bins = 60;
        int histSize[] = { h_bins, s_bins };
        // hue varies from 0 to 179, saturation from 0 to 255
        float h_ranges[] = { 0, 180 };
        float s_ranges[] = { 0, 256 };
        const float* ranges[] = { h_ranges, s_ranges };
        // Use the 0-th and 1-st channels
        int channels[] = { 0, 1 };

        Mat hist_base, hist_half_down, hist_test1, hist_test2;
        calcHist( &hsv_base, 1, channels, Mat(), hist_base, 2, histSize, ranges, true, false );
        normalize( hist_base, hist_base, 0, 1, NORM_MINMAX, -1, Mat() );
        calcHist( &hsv_test1, 1, channels, Mat(), hist_test1, 2, histSize, ranges, true, false );
        normalize( hist_test1, hist_test1, 0, 1, NORM_MINMAX, -1, Mat() );

        return compareHist( hist_base, hist_test1, 0 );

        /*
        double[4] score;
        for( int compare_method = 0; compare_method < 4; compare_method++ )
        {
            score[compare_method] = compareHist( hist_base, hist_test1, compare_method );
        }*/
    }
}
