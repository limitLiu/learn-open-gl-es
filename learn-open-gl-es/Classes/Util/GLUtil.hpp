//
//  GLUtil.hpp
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_GLUTIL_HPP
#define LEARN_OPEN_GL_ES_GLUTIL_HPP

#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/glext.h>
#import "Timer.hpp"

namespace glu {
    void SetupContext(GLKView *view);

    double GetTime();

    bool Init();

    void Clear();

    uint64_t PlatformGetTimerValue();

    uint64_t PlatformGetTimerFrequency();
}

#endif
