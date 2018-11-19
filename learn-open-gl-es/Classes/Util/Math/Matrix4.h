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

@property(nonatomic, assign) GLKMatrix4 identity;

- (GLKMatrix4)translate:(GLKVector3)vector3;

- (GLKMatrix4)scale:(GLKVector3)vector3;

- (GLKMatrix4)rotate:(float)radians vector3:(GLKVector3)vector3;

@end
