//
//  ViewController.m
//  learn-open-gl-es
//
//  Created by Limit Liu on 2018/10/8.
//  Copyright © 2018 limit. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/glext.h>

#import "ShaderProcessor.h"
#import "NSDate+func.h"

@interface ViewController () <GLKViewDelegate>

@property(nonatomic, assign) GLuint program;
@property(nonatomic, assign) GLuint vao;
@property(nonatomic, assign) GLuint vbo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContext];
    [self createProgram];
    [self triangle];
}

#pragma mark setup context

- (void)setupContext {
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) NSLog(@"Failed to create ES context");
    GLKView *view = (GLKView *) self.view;
    view.context = context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableColorFormat = GLKViewDrawableColorFormatSRGBA8888;
    [EAGLContext setCurrentContext:context];
}

#pragma mark create program

- (void)createProgram {
    ShaderProcessor *process = [[ShaderProcessor alloc] initWithFile:@"shader"];
    self.program = process.program;
}

#pragma mark gl config

- (void)triangle {
    GLKVector3 vec[3] = {
        // left
        {-0.5f, 0.0, 0.0},
        // right
        {0.5, 0.0, 0.0},
        // top
        {0.0, 0.5, 0.0}
    };
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.1, 0.2, 0.2, 1);
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vec), vec, GL_STATIC_DRAW);
    GLuint idx = (GLuint) glGetAttribLocation(self.program, "aPosition");
    glEnableVertexAttribArray(idx);
    glVertexAttribPointer(idx, 3, GL_FLOAT, GL_FALSE, sizeof(GLKVector3), NULL);
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
}

- (GLfloat)green {
    return (sin((GLfloat) NSDate.seconds) / 2.0f) + 0.5f;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindVertexArray(self.vao);
    glUseProgram(self.program);

    GLint vertexColorLocation = glGetUniformLocation(self.program, "ourColor");
    glUniform4f(vertexColorLocation, 0.0, self.green, 0.0, 1.0);

    glDrawArrays(GL_TRIANGLES, 0, 3);
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
