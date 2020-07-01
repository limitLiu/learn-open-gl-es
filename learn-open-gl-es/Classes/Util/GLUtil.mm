//
//  GLUtil.mm
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//

#import "GLUtil.hpp"

Timer *timer;

void glu::SetupContext(GLKView *view) {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) NSLog(@"Failed to create ES context");
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableColorFormat = GLKViewDrawableColorFormatSRGBA8888;
    EAGLContext.currentContext = context;
    glEnable(GL_DEPTH_TEST);
}

double glu::GetTime() {
    return timer->getTime();
}

bool glu::Init() {
    timer = new Timer();
    return timer->init();
}

void glu::Clear() {
    delete timer;
};

uint64_t glu::PlatformGetTimerValue() {
    return timer->platformGetTimerValue();
}

uint64_t glu::PlatformGetTimerFrequency() {
    return timer->platformGetTimerFrequency();
}
