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

+ (GLKMatrix4)rotate:(float)degrees x:(float)x y:(float)y z:(float)z {
    float radians = GLKMathDegreesToRadians(degrees);
    return GLKMatrix4MakeRotation(radians, x, y, z);
}

+ (GLKMatrix4)translate:(float)x y:(float)y z:(float)z {
    GLKMatrix4 mat4 = GLKMatrix4Identity;
    return GLKMatrix4Translate(mat4, x, y, z);
}

+ (GLKMatrix4)perspective:(float)degrees aspect:(float)aspect near:(float)near far:(float)far {
    float radians = GLKMathDegreesToRadians(degrees);
    return GLKMatrix4MakePerspective(radians, aspect, near, far);
}

- (GLKMatrix4)scale:(GLKVector3)vector3 {
    return GLKMatrix4ScaleWithVector3(self.identity, vector3);
}

@end
