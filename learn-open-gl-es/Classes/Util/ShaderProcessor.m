//
//  ShaderProcessor.m
//  learn-open-gl-es
//
//  Created by liuyu on 10/11/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "ShaderProcessor.h"

@implementation ShaderProcessor

- (instancetype)initWithFile:(NSString *)fileName {
    if (self = [super init]) {
        _program = [self createProgram:fileName];
    }
    return self;
}

- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
    const GLchar *source = (GLchar *) [[NSString stringWithContentsOfFile:file
                                                                 encoding:NSUTF8StringEncoding
                                                                    error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    *shader = glCreateShader(type);
    
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
    GLint log_len, status;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &log_len);
    if (log_len > 0) {
        GLchar *log = (GLchar *)malloc(log_len);
        glGetShaderInfoLog(*shader, log_len, &log_len, log);
        NSLog(@"shader compile log:\n%s", log);
        free(log);
    }
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

- (GLuint)createProgram:(NSString *)fileName {
    GLuint vertexShader = 0, fragmentShader = 0;
    NSString *v = [[NSBundle mainBundle] pathForResource:fileName ofType:@"vs"];
    NSString *f = [[NSBundle mainBundle] pathForResource:fileName ofType:@"fs"];
    [self compileShader:&vertexShader type:GL_VERTEX_SHADER file:v];
    [self compileShader:&fragmentShader type:GL_FRAGMENT_SHADER file:f];
    
    GLuint program = glCreateProgram();
    
    glAttachShader(program, vertexShader);
    glAttachShader(program, fragmentShader);
    BOOL linked = [self linkProgram:program];
    glDetachShader(program, vertexShader);
    glDeleteShader(vertexShader);
    glDetachShader(program, fragmentShader);
    glDeleteShader(fragmentShader);
    if (!linked) {
        NSLog(@"Failed to link program:%d\n", program);
        glDeleteProgram(program);
    }
    return program;
}

- (BOOL)linkProgram:(GLuint)program {
    glLinkProgram(program);
    GLint log_len, status;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &log_len);
    if (log_len > 0) {
        GLchar *log = (GLchar *)malloc(log_len);
        glGetProgramInfoLog(program, log_len, &log_len, log);
        NSLog(@"program link log:\n%s", log);
        free(log);
    }
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    if (status == 0) return NO;
    
    return YES;
}

@end
