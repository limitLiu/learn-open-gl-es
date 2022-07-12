//
//  UIImage+OpenCV.h
//  CaptureImage
//
//  Created by limit on 2022/7/1.
//

#include <opencv2/opencv.hpp>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (OpenCV)

+ (instancetype)imageWithCVMat:(const cv::Mat &)mat;
- (instancetype)initWithCVMat:(const cv::Mat &)mat;

- (cv::Mat)CVMat;
- (cv::Mat)CVMat3;
- (cv::Mat)CVGrayscaleMat;

- (cv::Mat)yuv;

@end

NS_ASSUME_NONNULL_END
