//
//  ShaderProcessor.m
//  learn-open-gl-es
//
//  Created by liuyu on 10/11/18.
//  Copyright © 2018 limit. All rights reserved.
//

#import "ShaderProcessor.h"

@implementation ShaderProcessor

+ (GLuint)loadShader {
    GLuint vertShader, fragShader;
    GLuint program = glCreateProgram();
    
    NSString *vertPath = [[NSBundle mainBundle]
                          pathForResource:@"shader.vs" ofType:nil];
    NSString *fragPath =[[NSBundle mainBundle]
                         pathForResource:@"shader.fs" ofType:nil];
    
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertPath]) {
        NSLog(@"Failed to compile vertex shader");
    }
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragPath]) {
        NSLog(@"Failed to compile fragment shader");
    }
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);
    
    if (![self linkProgram:program]) {
        NSLog(@"Failed to link program: %d\n", program);
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program) {
            glDeleteProgram(program);
            program = 0;
        }
    }
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }

    return program;
}

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file {
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

+ (BOOL)linkProgram:(GLuint)program {
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
