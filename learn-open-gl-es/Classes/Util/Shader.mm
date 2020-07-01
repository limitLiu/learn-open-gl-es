//
//  Shader.mm
//  learn-open-gl-es
//
//  Created by liuyu on 6/27/20.
//  Copyright © 2020 limit. All rights reserved.
//

#import "Shader.hpp"

#pragma mark - shader

Shader::Shader(NSString *filename) {
    GLuint vertexShader{};
    GLuint fragmentShader{};
    auto *v = [[NSBundle mainBundle] pathForResource:filename ofType:@"vert"];
    auto *f = [[NSBundle mainBundle] pathForResource:filename ofType:@"frag"];
    auto isCompileV = compile(vertexShader, GL_VERTEX_SHADER, v);
    auto isCompileS = compile(fragmentShader, GL_FRAGMENT_SHADER, f);
    if (isCompileV && isCompileS) {
        GLuint program = glCreateProgram();
        glAttachShader(program, vertexShader);
        glAttachShader(program, fragmentShader);
        auto linked = link(program);
        glDetachShader(program, vertexShader);
        glDeleteShader(vertexShader);
        glDetachShader(program, fragmentShader);
        glDeleteShader(fragmentShader);
        if (!linked) {
            NSLog(@"Failed to link program:%d\n", program);
            glDeleteProgram(program);
        }
        program_ = program;
    }
}

bool Shader::compile(GLuint &shader, GLenum type, NSString *file) {
    const GLchar *src = (GLchar *) [NSString
            stringWithContentsOfFile:file
                            encoding:NSUTF8StringEncoding
                               error:nil].UTF8String;
    if (!src) {
        NSLog(@"Failed to load vertex shader");
        return false;
    }

    shader = glCreateShader(type);
    glShaderSource(shader, 1, &src, nullptr);
    glCompileShader(shader);

    GLint logLen, status;
    glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLen);
    if (logLen > 0) {
        GLchar *log = (GLchar *) malloc((size_t) logLen);
        glGetShaderInfoLog(shader, logLen, &logLen, log);
        NSLog(@"shader compile log:\n%s", log);
        free(log);
    }
    glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(shader);
        return false;
    }
    return true;
}

bool Shader::link(GLuint program) {
    glLinkProgram(program);
    GLint logLen, status;
    glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLen);
    if (logLen > 0) {
        GLchar *log = (GLchar *) malloc((size_t) logLen);
        glGetProgramInfoLog(program, logLen, &logLen, log);
        NSLog(@"program link log:\n%s", log);
        free(log);
    }
    glGetProgramiv(program, GL_LINK_STATUS, &status);
    return status != 0;
}

void Shader::useProgram() {
    glUseProgram(program_);
}

#pragma mark - out operation

void Shader::setFloat(std::string name, GLfloat x) {
    GLint location = glGetUniformLocation(program_, name.c_str());
    glUniform1f(location, x);
}

void Shader::setInt(std::string name, GLint x) {
    GLint location = glGetUniformLocation(program_, name.c_str());
    glUniform1i(location, x);
}

void Shader::setMat4(std::string name, Matrix4<float> &mat) {
    GLint location = glGetUniformLocation(program_, name.c_str());
    glUniformMatrix4fv(location, 1, GL_FALSE, mat.getMat());
}

void Shader::setVec3(std::string name, float x, float y, float z) {
    GLint location = glGetUniformLocation(program_, name.c_str());
    glUniform3f(location, x, y, z);
}

void Shader::setVector3(std::string name, Vector3<float> vector3) {
    GLint location = glGetUniformLocation(program_, name.c_str());
    glUniform3fv(location, 1, vector3.toVec());
}
