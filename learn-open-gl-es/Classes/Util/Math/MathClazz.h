//
//  Math.h
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@class Matrix4;
@interface MathClazz : NSObject

+ (Matrix4 *)matrix4;

+ (float)radians:(float)degrees;

+ (GLKVector3)vec3_x:(float)x y:(float)y z:(float)z;

@end
