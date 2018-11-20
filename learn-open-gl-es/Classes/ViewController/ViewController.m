//
//  ViewController.m
//  learn-open-gl-es
//
//  Created by Limit Liu on 2018/10/8.
//  Copyright © 2018 limit. All rights reserved.
//

#import "ViewController.h"
#import <OpenGLES/ES3/glext.h>

#import "NSDate+func.h"
#import "ShaderProcessor.h"
#import "MathClazz.h"
#import "Matrix4.h"

@interface ViewController () <GLKViewDelegate>

@property(nonatomic, strong) ShaderProcessor *processor;
@property(nonatomic, assign) GLuint vao;
@property(nonatomic, assign) GLuint vbo;
@property(nonatomic, assign) GLuint ebo;
@property(nonatomic, assign) GLuint texture1;
@property(nonatomic, assign) GLuint texture2;

@property(nonatomic, assign) GLfloat mixVal;

@property(nonatomic, strong) Matrix4 *mat4;


@end

@implementation ViewController

- (Matrix4 *)mat4 {
    if (!_mat4) {
        _mat4 = MathClazz.matrix4;
    }
    return _mat4;
}

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
    EAGLContext.currentContext = context;
}

#pragma mark create program

- (void)createProgram {
    self.processor = [[ShaderProcessor alloc] initWithFile:@"shader"];
}

#pragma mark gl config

- (void)triangle {
    GLfloat vec[32] = {
            // right top             color             texture
            0.8f, 0.4f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f, 1.0f,
            // right bottom
            0.8f, -0.4f, 0.0f, 0.0f, 1.0f, 0.0f, 1.0f, 0.0f,
            // left bottom
            -0.8f, -0.4f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f,
            // left top
            -0.8f, 0.4f, 0.0f, 1.0f, 1.0f, 0.0f, 0.0f, 1.0f
    };

    GLuint indices[6] = {
            0, 1, 3, 1, 2, 3
    };

    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    glGenBuffers(1, &_vbo);
    glGenBuffers(1, &_ebo);

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vec), vec, GL_STATIC_DRAW);

    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _ebo);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    GLuint aPosition = 0;
    glVertexAttribPointer(aPosition, 3, GL_FLOAT, GL_FALSE,
            8 * sizeof(GLfloat), (void *) 0);
    glEnableVertexAttribArray(aPosition);

    GLuint aColor = 1;
    glVertexAttribPointer(aColor, 3, GL_FLOAT, GL_FALSE,
            8 * sizeof(GLfloat), (void *) (3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(aColor);

    GLuint aTexCoord = 2;
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE,
            8 * sizeof(GLfloat), (void *) (6 * sizeof(GLfloat)));
    glEnableVertexAttribArray(aTexCoord);

    NSString *bundle = [[NSBundle mainBundle] pathForResource:@"textures" ofType:@"bundle"];
    UIImage *img1 = [UIImage imageWithContentsOfFile:
            [bundle stringByAppendingPathComponent:@"container.jpg"]];
    UIImage *img2 = [UIImage imageWithContentsOfFile:
            [bundle stringByAppendingPathComponent:@"awesomeface.png"]];
    [self createTexture:&_texture1 image:img1];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    [self createTexture:&_texture2 image:img2];
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);

    [self.processor useProgram];
    [self.processor setInt:"texture1" value:(GL_TEXTURE0 - GL_TEXTURE0)];
    [self.processor setInt:"texture2" value:(GL_TEXTURE1 - GL_TEXTURE0)];

    self.mat4.identity = [self.mat4 translate:[MathClazz vec3_x:0.2f y:-0.2f z:0.0f]];
}

- (void)createTexture:(GLuint *)tex image:(UIImage *)image {
    CGImageRef cgImgRef = image.CGImage;
    size_t width = CGImageGetWidth(cgImgRef);
    size_t height = CGImageGetHeight(cgImgRef);
    void *data = malloc(width * height * 4);
    CGRect rect = {0, 0, width, height};

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(data, width, height, 8,
            width * 4,
            colorSpace,
            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImgRef);

    glGenTextures(1, tex);
    glBindTexture(GL_TEXTURE_2D, *tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei) width, (GLsizei) height, 0, GL_RGBA, GL_UNSIGNED_BYTE, data);
    glGenerateMipmap(GL_TEXTURE_2D);

    free(data);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture1);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _texture2);

    GLfloat rotate = NSDate.seconds / 1000.0f;
    self.mat4.identity = [self.mat4 rotate:rotate
                                   vector3:[MathClazz vec3_x:0.0f y:0.0f z:1.0f]];

    [self.processor setFloat:"mixVal" value:_mixVal];
    [self.processor useProgram];

    GLKMatrix4 matrix4 = self.mat4.identity;
    GLint location = glGetUniformLocation(self.processor.program, "transform");
    glUniformMatrix4fv(location, 1, GL_FALSE, (GLfloat *) &matrix4.m);

    glBindVertexArray(_vao);
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, (void *) 0);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches objectEnumerator].nextObject;
    CGPoint prevLoc = [touch previousLocationInView:self.view];
    CGPoint loc = [touch locationInView:self.view];
    if ((loc.y - prevLoc.y) > 0) {
        self.mixVal += 0.01f;
        //        if (self.mixVal >= 1.0f) self.mixVal = 1.0;
    } else {
        self.mixVal -= 0.01f;
        //        if (self.mixVal <= 0.0f) self.mixVal = 0.0;
    }
}

- (void)dealloc {
    glDeleteVertexArrays(1, &_vao);
    glDeleteBuffers(1, &_vbo);
    glDeleteBuffers(1, &_ebo);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
