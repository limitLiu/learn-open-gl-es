//
//  ViewController.m
//  Renderer
//
//  Created by limit on 2022/7/3.
//

#import "ViewController.h"
#import <GLKit/GLKView.h>
#import "LLScene.hpp"
#import "TrackerWrapper.h"

@interface ViewController () <GLKViewDelegate, LLTrackerDelegate>

@property(nonatomic, assign) Renderer::Scene *scene;
@property(nonatomic, strong) TrackerWrapper *tracker;

@end

@implementation ViewController

- (void)loadView {
  [super loadView];
  self.view = [[GLKView alloc] initWithFrame:self.view.frame];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupContext];
  [self setupProperties];
}

- (void)setupContext {
  auto context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
  if (!context) {
    NSLog(@"Failed to init context.");
  }
  GLKView *view = (GLKView *) self.view;
  view.context = context;
  view.delegate = self;
  view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
  view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
  view.enableSetNeedsDisplay = YES;
  [EAGLContext setCurrentContext:context];
}

- (void)setupProperties {
  self.scene = new Renderer::Scene([NSBundle.mainBundle resourcePath].UTF8String);
  self.tracker = [[TrackerWrapper alloc] init];
  self.tracker.delegate = self;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
  if (self.scene != nullptr) {
    self.scene->render();
  }
}

- (void)updateTrackingFrame:(LLYUVFrame *)frame {
  if (frame != nullptr) {
    self.scene->updateYUVFrame(frame);
  }
  dispatch_sync(dispatch_get_main_queue(), ^{
    [self.view setNeedsDisplay];
  });
}

- (void)updateTrackingInfo:(CGPoint)position scale:(float)scale {
  auto point = glm::vec2(position.x, position.y);
  self.scene->updateTrackingInfo(point, scale);
}

- (void)dealloc {
  deletePtr(self.scene);
}

@end
