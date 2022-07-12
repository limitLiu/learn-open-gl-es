#ifndef TRACKER_H
#define TRACKER_H

#include <opencv2/opencv.hpp>

typedef struct {
  float x;
  float y;
} TrackerPoint;

#ifdef __cplusplus
extern "C" {
#endif

bool tracker_init(const char* filePath);

bool tracker_track(cv::Mat &image);

void tracker_set_draw(int drawable);

TrackerPoint tracker_position();

float tracker_scale();

#ifdef __cplusplus
}
#endif

#endif // TRACKER_H
