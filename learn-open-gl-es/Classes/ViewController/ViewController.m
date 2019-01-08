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
#import "Matrix4.h"

@interface ViewController () <GLKViewDelegate> {
@private
    GLKVector3 _cubes[10];
}

@property(nonatomic, strong) ShaderProcessor *processor;
@property(nonatomic, assign) GLuint vao;
@property(nonatomic, assign) GLuint vbo;
@property(nonatomic, assign) GLuint texture1;
@property(nonatomic, assign) GLuint texture2;

@property(nonatomic, assign) CGFloat screenWidth;
@property(nonatomic, assign) CGFloat screenHeight;

@property(nonatomic, assign) GLKVector3 front;
@property(nonatomic, assign) GLKVector3 up;
@property(nonatomic, assign) GLKVector3 pos;

@end

@implementation ViewController

#pragma mark setter/getter

- (void)setCubes:(GLKVector3 *)cubes {
    if (cubes != NULL) {
        for (int i = 0; i < 10; i++) {
            _cubes[i] = cubes[i];
        }
    }
}

- (GLKVector3 *)cubes {
    return _cubes;
}

- (CGFloat)screenWidth {
    if (!_screenWidth) {
        _screenWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return _screenWidth;
}

- (CGFloat)screenHeight {
    if (!_screenHeight) {
        _screenHeight = [UIScreen mainScreen].bounds.size.height;
    }
    return _screenHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContext];
    [self configVector];
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
    glEnable(GL_DEPTH_TEST);
}

#pragma mark create program

- (void)createProgram {
    self.processor = [[ShaderProcessor alloc] initWithFile:@"shader"];
}

#pragma mark config pos front up Vector

- (void)configVector {
    float pos[3] = {0.0f, 0.0f, 3.0f};
    self.pos = GLKVector3MakeWithArray(pos);
    float front[3] = {0.0f, 0.0f, -1.0f};
    self.front = GLKVector3MakeWithArray(front);
    float up[3] = {0.0f, 1.0f, 0.0f};
    self.up = GLKVector3MakeWithArray(up);
}

#pragma mark gl config

- (void)triangle {
    GLfloat vec[180] = {
            //
            -0.3f, -0.3f, -0.3f, 0.0, 0.0,
            0.3, -0.3f, -0.3f, 1.0, 0.0,
            0.3, 0.3, -0.3f, 1.0, 1.0,
            0.3, 0.3, -0.3f, 1.0, 1.0,
            -0.3f, 0.3, -0.3f, 0.0, 1.0,
            -0.3f, -0.3f, -0.3f, 0.0, 0.0,
            //
            -0.3f, -0.3f, 0.3, 0.0, 0.0,
            0.3, -0.3f, 0.3, 1.0, 0.0,
            0.3, 0.3, 0.3, 1.0, 1.0,
            0.3, 0.3, 0.3, 1.0, 1.0,
            -0.3f, 0.3, 0.3, 0.0, 1.0,
            -0.3f, -0.3f, 0.3, 0.0, 0.0,
            //
            -0.3f, 0.3, 0.3, 1.0, 0.0,
            -0.3f, 0.3, -0.3f, 1.0, 1.0,
            -0.3f, -0.3f, -0.3f, 0.0, 1.0,
            -0.3f, -0.3f, -0.3f, 0.0, 1.0,
            -0.3f, -0.3f, 0.3, 0.0, 0.0,
            -0.3f, 0.3, 0.3, 1.0, 0.0,
            //
            0.3, 0.3, 0.3, 1.0, 0.0,
            0.3, 0.3, -0.3f, 1.0, 1.0,
            0.3, -0.3f, -0.3f, 0.0, 1.0,
            0.3, -0.3f, -0.3f, 0.0, 1.0,
            0.3, -0.3f, 0.3, 0.0, 0.0,
            0.3, 0.3, 0.3, 1.0, 0.0,
            //
            -0.3f, -0.3f, -0.3f, 0.0, 1.0,
            0.3, -0.3f, -0.3f, 1.0, 1.0,
            0.3, -0.3f, 0.3, 1.0, 0.0,
            0.3, -0.3f, 0.3, 1.0, 0.0,
            -0.3f, -0.3f, 0.3, 0.0, 0.0,
            -0.3f, -0.3f, -0.3f, 0.0, 1.0,
            //
            -0.3f, 0.3, -0.3f, 0.0, 1.0,
            0.3, 0.3, -0.3f, 1.0, 1.0,
            0.3, 0.3, 0.3, 1.0, 0.0,
            0.3, 0.3, 0.3, 1.0, 0.0,
            -0.3f, 0.3, 0.3, 0.0, 0.0,
            -0.3f, 0.3, -0.3f, 0.0, 1.0
    };

    GLKVector3 cubes[] = {
            GLKVector3Make(0.0f, 0.0f, 0.0f),
            GLKVector3Make(2.0f, 5.0f, -15.0f),
            GLKVector3Make(-1.5f, -2.2f, -2.5f),
            GLKVector3Make(-3.8f, -2.0f, -12.3f),
            GLKVector3Make(2.4f, -0.4f, -3.5f),
            GLKVector3Make(-1.7f, 3.0f, -7.5f),
            GLKVector3Make(1.3f, -2.0f, -2.5f),
            GLKVector3Make(1.5f, 2.0f, -2.5f),
            GLKVector3Make(1.5f, 0.2f, -1.5f),
            GLKVector3Make(-1.3f, 1.0f, -1.5f)
    };
    self.cubes = cubes;

    glGenVertexArrays(1, &_vao);
    glBindVertexArray(_vao);
    glGenBuffers(1, &_vbo);

    glBindBuffer(GL_ARRAY_BUFFER, _vbo);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vec), vec, GL_STATIC_DRAW);

    GLuint aPosition = 0;
    glVertexAttribPointer(aPosition, 3, GL_FLOAT, GL_FALSE,
            5 * sizeof(GLfloat), (void *) 0);
    glEnableVertexAttribArray(aPosition);

    GLuint aTexCoord = 1;
    glVertexAttribPointer(aTexCoord, 2, GL_FLOAT, GL_FALSE,
            5 * sizeof(GLfloat), (void *) (3 * sizeof(GLfloat)));
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

    float aspect = (float) (self.screenWidth) / (float) (self.screenHeight);
    GLKMatrix4 projectionMatrix = [Matrix4 perspective:45.0f aspect:aspect near:0.1f far:100.0f];
    [self.processor setMat4:"projection" value:projectionMatrix];
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
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture1);

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _texture2);

    [self.processor useProgram];

    GLKVector3 added = GLKVector3Add(self.pos, self.front);
    GLKMatrix4 viewMatrix = [Matrix4 lookAt:self.pos center:added up:self.up];

    [self.processor setMat4:"view" value:viewMatrix];

    glBindVertexArray(_vao);

    for (int i = 1; i < 11; i++) {
        GLKVector3 cube = self.cubes[i - 1];
        GLKMatrix4 m = [Matrix4 translate:cube.v[0] y:cube.v[1] z:cube.v[2]];
        float angle = 20.0f * i;
        m = GLKMatrix4RotateWithVector3(m, GLKMathDegreesToRadians(angle), GLKVector3Make(1.0f, 0.3f, 0.3f));
        [self.processor setMat4:"model" value:m];
        glDrawArrays(GL_TRIANGLES, 0, 36);
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint prevLoc = [touch previousLocationInView:self.view];
    CGPoint loc = [touch locationInView:self.view];
    [self processTouch:loc prevLoc:prevLoc];
}

- (void)processTouch:(CGPoint)loc prevLoc:(CGPoint)prevLoc {
    float cameraSpeed = 0.05f;

    GLKVector3 f = GLKVector3MultiplyScalar(self.front, cameraSpeed);
    if (loc.y - prevLoc.y > 0) {
        self.pos = GLKVector3Add(self.pos, f);
    } else {
        self.pos = GLKVector3Subtract(self.pos, f);
    }

    GLKVector3 tmp = GLKVector3MultiplyScalar(GLKVector3Normalize(GLKVector3CrossProduct(self.front, self.up)),
            cameraSpeed);
    if (loc.x - prevLoc.x > 0) {
        self.pos = GLKVector3Add(self.pos, tmp);
    } else {
        self.pos = GLKVector3Subtract(self.pos, tmp);
    }

}

- (void)dealloc {
    glDeleteVertexArrays(1, &_vao);
    glDeleteBuffers(1, &_vbo);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
