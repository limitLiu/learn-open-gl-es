//
//  UIImage+OpenCV.m
//  CaptureImage
//
//  Created by limit on 2022/7/1.
//

#import "UIImage+OpenCV.h"

@implementation UIImage (OpenCV)

+ (instancetype)imageWithCVMat:(const cv::Mat &)mat {
  return [[self alloc] initWithCVMat:mat];
}

- (instancetype)initWithCVMat:(const cv::Mat &)mat {
  auto data = [NSData dataWithBytes:mat.data length:mat.elemSize() * mat.total()];
  CGColorSpaceRef colorSpace = mat.elemSize() == 1 ? CGColorSpaceCreateDeviceGray() : CGColorSpaceCreateDeviceRGB();
  auto provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  auto imageRef = CGImageCreate(mat.cols, mat.rows, 8, 8 * mat.elemSize(), mat.step[0], colorSpace, kCGImageAlphaNone | kCGBitmapByteOrderDefault, provider, nullptr, false, kCGRenderingIntentDefault);
  self = [self initWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  return self;
}

- (cv::Mat)CVMat {
  auto colorSpace = CGImageGetColorSpace(self.CGImage);
  auto cols = self.size.width;
  auto rows = self.size.height;
  cv::Mat mat(rows, cols, CV_8UC4);
  auto contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
  CGContextRelease(contextRef);
  CGColorSpaceRelease(colorSpace);
  return mat;
}

- (cv::Mat)CVMat3 {
  auto result = self.CVMat;
  cv::cvtColor(result, result, cv::COLOR_RGBA2RGB);
  return result;
}

- (cv::Mat)CVGrayscaleMat {
  auto colorSpace = CGImageGetColorSpace(self.CGImage);
  auto cols = self.size.width;
  auto rows = self.size.height;
  cv::Mat mat(rows, cols, CV_8UC1);
  auto contextRef = CGBitmapContextCreate(mat.data, cols, rows, 8, mat.step[0], colorSpace, kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
  CGContextRelease(contextRef);
  CGColorSpaceRelease(colorSpace);
  return mat;
}

- (cv::Mat)yuv {
  auto mat = self.CVMat;
  
  return mat;
}

@end
