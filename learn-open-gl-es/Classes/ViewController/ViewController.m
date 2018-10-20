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

@property(nonatomic, strong) ShaderProcessor *processor;
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
     self.processor = [[ShaderProcessor alloc] initWithFile:@"shader"];
}

#pragma mark gl config

- (void)triangle {
    GLfloat vec[18] = {
        // left
        -0.5f, -0.1f, 0.0f, 0.0f, 1.0f, 0.0f,
        // right
        0.5f, -0.1f, 0.0f, 1.0f, 0.0f, 0.0f,
        // top
        0.0f, 0.4f, 0.0f, 0.0f, 0.0f, 1.0f
    };
    glEnable(GL_DEPTH_TEST);
    glClearColor(0.1, 0.2, 0.2, 1);
    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    glGenBuffers(1, &_vbo);
    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vec), vec, GL_STATIC_DRAW);
    GLuint aPosition = 0;
    glVertexAttribPointer(aPosition, 3, GL_FLOAT, GL_FALSE,
                          6 * sizeof(GLfloat), (void *)0);
    glEnableVertexAttribArray(aPosition);
    
    GLuint aColor = 1;
    glVertexAttribPointer(aColor, 3, GL_FLOAT, GL_FALSE,
                          6 * sizeof(GLfloat), (void *)(3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(aColor);

    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    [self.processor useProgram];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glBindVertexArray(self.vao);
    glDrawArrays(GL_TRIANGLES, 0, 3);
    [self.processor setFloat:@"yOffset" value:0.1f];
    glBindVertexArray(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
