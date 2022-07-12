//
//  TrackerWrapper.m
//  CaptureImage
//
//  Created by limit on 2022/6/26.
//

#import "tracker.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+OpenCV.h"
#import "TrackerWrapper.h"

@interface TrackerWrapper () <AVCaptureVideoDataOutputSampleBufferDelegate>

@end

@implementation TrackerWrapper

- (instancetype)init {
  if (self = [super init]) {
    [self start];
  }
  return self;
}

- (void)start {
  self.session = [[AVCaptureSession alloc] init];
  auto device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
  NSError *error;
  auto input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
  if (error) {
    NSLog(@"Failed to init input device. %@", error);
    return;
  }
  [self.session addInput:input];
  auto queue = dispatch_queue_create("wiki.mdzz.Renderer", DISPATCH_QUEUE_SERIAL);
  self.output = [[AVCaptureVideoDataOutput alloc] init];
  self.output.alwaysDiscardsLateVideoFrames = YES;
  self.output.videoSettings = @{
    (__bridge NSString *)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)
  };
  [self.output setSampleBufferDelegate:self queue:queue];
  [self.session addOutput:self.output];
  self.session.connections[0].videoOrientation = AVCaptureVideoOrientationPortrait;
  tracker_init([NSBundle.mainBundle resourcePath].UTF8String);
  tracker_set_draw(1);
  [self.session commitConfiguration];
  [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
  auto pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  if (!pixelBuffer) {
    return;
  }
  cv::Mat bgrMat;
  CVPixelBufferLockBaseAddress(pixelBuffer, 0);
  auto address = CVPixelBufferGetBaseAddress(pixelBuffer);
  int height = (int) CVPixelBufferGetWidth(pixelBuffer);
  int width = (int) CVPixelBufferGetHeight(pixelBuffer);
  cv::Mat imageMat = cv::Mat(width, height, CV_8UC4, address, 0);
  cv::cvtColor(imageMat, bgrMat, cv::COLOR_BGRA2BGR);
  cv::flip(bgrMat, bgrMat, 1);
  auto size = cv::Size(1080, 1920);
  cv::resize(bgrMat, bgrMat, size);
  width = size.width;
  height = size.height;
  
  tracker_track(bgrMat);
  CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
  auto position = tracker_position();
  auto scale = tracker_scale();
  if ([self.delegate respondsToSelector:@selector(updateTrackingInfo:scale:)]) {
    auto point = CGPointMake(position.x, position.y);
    [self.delegate updateTrackingInfo:point scale:scale];
  }
  
  cv::Mat yuvMat;
  cv::cvtColor(bgrMat, yuvMat, cv::COLOR_BGR2YUV_I420);
  auto lumaSize = width * height;
  auto chromaSize = lumaSize / 4;
  uint8_t *yData = yuvMat.data;
  uint8_t *uData = yuvMat.data + lumaSize;
  uint8_t *vData = yuvMat.data + lumaSize + chromaSize;
  
  LLYUVFrame yuvFrame;
  memset(&yuvFrame, 0, sizeof(yuvFrame));
  
  yuvFrame.luma.data = yData;
  yuvFrame.chromaB.data = uData;
  yuvFrame.chromaR.data = vData;
  
  yuvFrame.luma.length = lumaSize;
  yuvFrame.chromaB.length = chromaSize;
  yuvFrame.chromaR.length = chromaSize;
  
  yuvFrame.width = width;
  yuvFrame.height = height;
  
  if ([self.delegate respondsToSelector:@selector(updateTrackingFrame:)]) {
    [self.delegate updateTrackingFrame:&yuvFrame];
  }
}

@end
