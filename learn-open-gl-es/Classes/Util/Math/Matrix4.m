//
//  Matrix4.m
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "Matrix4.h"
#import "MathClazz.h"

@implementation Matrix4

- (instancetype)init {
    if (self = [super init]) {
        self.identity = GLKMatrix4Identity;
    }
    return self;
}

- (GLKMatrix4)translate:(GLKVector3)vector3 {
    return GLKMatrix4TranslateWithVector3(self.identity, vector3);
}

- (GLKMatrix4)rotate:(float)radians vector3:(GLKVector3)vector3 {
    return GLKMatrix4RotateWithVector3(self.identity, radians, vector3);
}

- (GLKMatrix4)scale:(GLKVector3)vector3 {
    return GLKMatrix4ScaleWithVector3(self.identity, vector3);
}

@end
