//
//  Vector3.m
//  learn-open-gl-es
//
//  Created by liuyu on 11/20/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "Vector.h"

@implementation Vector

+ (GLKVector3)vec3:(float)x y:(float)y z:(float)z {
    return GLKVector3Make(x, y, z);
}

@end
