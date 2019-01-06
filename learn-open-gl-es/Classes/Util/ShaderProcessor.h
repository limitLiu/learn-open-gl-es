//
//  ShaderProcessor.h
//  learn-open-gl-es
//
//  Created by liuyu on 10/11/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface ShaderProcessor : NSObject

@property (nonatomic, assign) GLuint program;

- (instancetype)initWithFile:(NSString *)fileName;

- (void)setFloat:(GLchar *)name value:(GLfloat)x;
- (void)setInt:(GLchar *)name value:(GLint)x;
- (void)setMat4:(GLchar *)name value:(GLKMatrix4)x;

- (void)useProgram;

@end
