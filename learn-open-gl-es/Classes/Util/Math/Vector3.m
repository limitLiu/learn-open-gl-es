//
// Created by LimitLiu on 2019-01-07.
// Copyright (c) 2019 limit. All rights reserved.
//

#import "Vector3.h"


@implementation Vector3

+ (float *)add:(float *)left right:(float *)right {
    float v[3] = {left[0] + right[0], left[1] + right[1], left[2] + right[2]};
    return (float *) v;
}

@end