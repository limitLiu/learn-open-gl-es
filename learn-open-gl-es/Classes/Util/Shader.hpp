//
//  Shader.hpp
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//

#ifndef LEARN_OPEN_GL_ES_SHADER_HPP
#define LEARN_OPEN_GL_ES_SHADER_HPP

#import <Foundation/Foundation.h>
#import <string>
#import <GLKit/GLKit.h>
#import "Matrix4.hpp"
#import "Vector3.hpp"

class Shader {
public:
    Shader(NSString *filename);

    GLuint program_;

    void useProgram();

    void setFloat(std::string name, GLfloat x);

    void setInt(std::string name, GLint x);

    void setMat4(std::string name, Matrix4<float> &mat);

    void setVec3(std::string name, float x, float y, float z);

    void setVector3(std::string name, Vector3<float> vector);

private:
    bool compile(GLuint &shader, GLenum type, NSString *file);

    bool link(GLuint program);
};

#endif
