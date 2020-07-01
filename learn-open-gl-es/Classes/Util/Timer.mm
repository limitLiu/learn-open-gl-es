//
// Created by liuyu on 6/29/20.
// Copyright (c) 2020 limit. All rights reserved.
//

#import "Timer.hpp"

bool Timer::init() {
    if (initialized_) {
        return true;
    }
    initialized_ = true;
    timer_.offset = platformGetTimerValue();

    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    timer_.ns.frequency = (info.denom * 1e9) / info.numer;

    return true;
}

uint64_t Timer::platformGetTimerValue() {
    return mach_absolute_time();
}

double Timer::getTime() {
    if (!initialized_) {
        return 0.0;
    }
    return (double) (platformGetTimerValue() - timer_.offset) / platformGetTimerFrequency();
}

uint64_t Timer::platformGetTimerFrequency() {
    return timer_.ns.frequency;
}
