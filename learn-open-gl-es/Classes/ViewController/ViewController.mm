//
//  ViewController.m
//  learn-open-gl-es
//
//  Created by Limit Liu on 2018/10/8.
//  Copyright © 2018 limit. All rights reserved.
//

#import "ViewController.h"
#import "Shader.hpp"
#import "GLUtil.hpp"
#import "Camera.hpp"

const CGFloat SCR_W = [UIScreen mainScreen].bounds.size.width;
const CGFloat SCR_H = [UIScreen mainScreen].bounds.size.height;

@interface ViewController () <GLKViewDelegate>

@property(nonatomic, assign) GLuint cubeVAO;
@property(nonatomic, assign) GLuint lightVAO;
@property(nonatomic, assign) GLuint VBO;

// Cpp class
@property(nonatomic, assign) Shader *light;
@property(nonatomic, assign) Shader *lamp;
@property(nonatomic, assign) Camera<> *camera;

@end

@implementation ViewController


#pragma mark override

- (void)dealloc {
    delete self.light;
    delete self.lamp;
    delete self.camera;
    glu::Clear();
    glDeleteVertexArrays(1, &_cubeVAO);
    glDeleteVertexArrays(1, &_lightVAO);
    glDeleteBuffers(1, &_VBO);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - setup context

- (void)viewDidLoad {
    if (glu::Init()) {
        self.camera = Camera<>::init();
        glu::SetupContext((GLKView *) self.view);
        self.light = new Shader(@"light");
        self.lamp = new Shader(@"lamp");
        [self triangle];
    }
}

#pragma mark triangle

- (void)triangle {
    GLfloat vertices[216] = {
            -0.5f, -0.5f, -0.5f, 0.0f, 0.0f, -1.0f,
            0.5f, -0.5f, -0.5f, 0.0f, 0.0f, -1.0f,
            0.5f, 0.5f, -0.5f, 0.0f, 0.0f, -1.0f,
            0.5f, 0.5f, -0.5f, 0.0f, 0.0f, -1.0f,
            -0.5f, 0.5f, -0.5f, 0.0f, 0.0f, -1.0f,
            -0.5f, -0.5f, -0.5f, 0.0f, 0.0f, -1.0f,

            -0.5f, -0.5f, 0.5f, 0.0f, 0.0f, 1.0f,
            0.5f, -0.5f, 0.5f, 0.0f, 0.0f, 1.0f,
            0.5f, 0.5f, 0.5f, 0.0f, 0.0f, 1.0f,
            0.5f, 0.5f, 0.5f, 0.0f, 0.0f, 1.0f,
            -0.5f, 0.5f, 0.5f, 0.0f, 0.0f, 1.0f,
            -0.5f, -0.5f, 0.5f, 0.0f, 0.0f, 1.0f,

            -0.5f, 0.5f, 0.5f, -1.0f, 0.0f, 0.0f,
            -0.5f, 0.5f, -0.5f, -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f, -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, -0.5f, -1.0f, 0.0f, 0.0f,
            -0.5f, -0.5f, 0.5f, -1.0f, 0.0f, 0.0f,
            -0.5f, 0.5f, 0.5f, -1.0f, 0.0f, 0.0f,

            0.5f, 0.5f, 0.5f, 1.0f, 0.0f, 0.0f,
            0.5f, 0.5f, -0.5f, 1.0f, 0.0f, 0.0f,
            0.5f, -0.5f, -0.5f, 1.0f, 0.0f, 0.0f,
            0.5f, -0.5f, -0.5f, 1.0f, 0.0f, 0.0f,
            0.5f, -0.5f, 0.5f, 1.0f, 0.0f, 0.0f,
            0.5f, 0.5f, 0.5f, 1.0f, 0.0f, 0.0f,

            -0.5f, -0.5f, -0.5f, 0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, -0.5f, 0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, 0.5f, 0.0f, -1.0f, 0.0f,
            0.5f, -0.5f, 0.5f, 0.0f, -1.0f, 0.0f,
            -0.5f, -0.5f, 0.5f, 0.0f, -1.0f, 0.0f,
            -0.5f, -0.5f, -0.5f, 0.0f, -1.0f, 0.0f,

            -0.5f, 0.5f, -0.5f, 0.0f, 1.0f, 0.0f,
            0.5f, 0.5f, -0.5f, 0.0f, 1.0f, 0.0f,
            0.5f, 0.5f, 0.5f, 0.0f, 1.0f, 0.0f,
            0.5f, 0.5f, 0.5f, 0.0f, 1.0f, 0.0f,
            -0.5f, 0.5f, 0.5f, 0.0f, 1.0f, 0.0f,
            -0.5f, 0.5f, -0.5f, 0.0f, 1.0f, 0.0f
    };
    glGenVertexArrays(1, &_cubeVAO);
    glBindVertexArray(_cubeVAO);
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    GLuint aPosition = 0, aNormal = 1;
    GLsizei stride = 6 * sizeof(GLfloat);
    glVertexAttribPointer(aPosition, 3, GL_FLOAT, GL_FALSE, stride, (void *) 0);
    glEnableVertexAttribArray(aPosition);

    glVertexAttribPointer(aNormal, 3, GL_FLOAT, GL_FALSE, stride, (void *) (3 * sizeof(GLfloat)));
    glEnableVertexAttribArray(aNormal);

    glGenVertexArrays(1, &_lightVAO);
    glBindVertexArray(_lightVAO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glVertexAttribPointer(aPosition, 3, GL_FLOAT, GL_FALSE, stride, (void *) 0);
    glEnableVertexAttribArray(aPosition);
}

#pragma mark render

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.2, 0.3, 0.3, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    self.light->useProgram();
    self.light->setVector3("light.position", Vector3<float>(1.2f, 1.f, 2.f));

    auto projection = Matrix4<float>::perspective(GLKMathDegreesToRadians(self.camera->zoom), static_cast<float>(SCR_W / SCR_H), 0.1f, 100.f);
    self.light->setMat4("projection", projection);

    auto time = glu::GetTime();
    auto lightColor = Vector3<float>(static_cast<float>(sin(time * 2.0)), static_cast<float>(sin(time * 0.7)), static_cast<float>(sin(time * 1.3)));
    auto diffuseColor = lightColor * 0.5f;
    self.light->setVector3("light.diffuse", diffuseColor);

    self.light->setVec3("material.diffuse", 1.0f, 0.5f, 0.31f);

    auto viewMat = self.camera->getViewMat();
    self.light->setMat4("view", viewMat);

    auto model = Matrix4<float>::Identity();
    self.light->setMat4("model", model);

    glBindVertexArray(_cubeVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);

    self.lamp->useProgram();
    self.lamp->setMat4("projection", projection);
    self.lamp->setMat4("view", viewMat);
    model = Matrix4<float>::translate(1.2f, 1.0f, 2.0f);
    model = model * (Matrix4<float>::scale(0.2f, 0.2f, 0.2f));
    self.lamp->setMat4("model", model);
    glBindVertexArray(_lightVAO);
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

@end
