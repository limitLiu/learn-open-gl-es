//
//  TrackerWrapper.h
//  CaptureImage
//
//  Created by limit on 2022/6/26.
//

#import <UIKit/UIKit.h>
#import "LLDefine.h"

@protocol LLTrackerDelegate <NSObject>

@optional
- (void)updateTrackingFrame:(LLYUVFrame * _Nullable)frame;

- (void)updateTrackingInfo:(CGPoint)position scale:(float)scale;

@end

NS_ASSUME_NONNULL_BEGIN

@class AVCaptureSession;
@class AVCaptureVideoDataOutput;
@interface TrackerWrapper : NSObject

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureVideoDataOutput *output;
@property(nonatomic, weak) id<LLTrackerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
