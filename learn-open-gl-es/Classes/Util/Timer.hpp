//
// Created by liuyu on 6/29/20.
// Copyright (c) 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_TIMER_HPP
#define LEARN_OPEN_GL_ES_TIMER_HPP

#import <Foundation/Foundation.h>
#import <mach/mach_time.h>

struct TimerNS_ {
    uint64_t frequency;
};

struct Timer_ {
    uint64_t offset;
    TimerNS_ ns;
};

class Timer {
public:
    bool initialized_;
    Timer_ timer_;

    bool init();

    uint64_t platformGetTimerValue();

    double getTime();

    uint64_t platformGetTimerFrequency();
};

#endif //LEARN_OPEN_GL_ES_TIMER_HPP
