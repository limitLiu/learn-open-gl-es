//
//  Matrix4.h
//  learn-open-gl-es
//
//  Created by liuyu on 11/19/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface Matrix4 : NSObject

+ (GLKMatrix4)translate:(float)x y:(float)y z:(float)z;
+ (GLKMatrix4)translate:(GLKMatrix4)mat4 x:(float)x y:(float)y z:(float)z;

+ (GLKMatrix4)scale:(float)x y:(float)y z:(float)z;

+ (GLKMatrix4)rotate:(float)radians x:(float)x y:(float)y z:(float)z;
+ (GLKMatrix4)rotate:(GLKMatrix4)mat4 radians:(float)radians x:(float)x y:(float)y z:(float)z;

@end
