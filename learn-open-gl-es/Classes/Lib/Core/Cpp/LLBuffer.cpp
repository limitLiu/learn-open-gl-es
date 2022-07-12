//
//  LLBuffer.cpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#include "LLBuffer.hpp"

Renderer::Buffer::Buffer(Kind kind, UsagePattern usage) {
  size_ = 0;
  usage_ = usage;
  kind_ = kind;
  glGenBuffers(1, &bufferID_);
}

Renderer::Buffer::~Buffer() {
  glDeleteBuffers(1, &bufferID_);
}

[[maybe_unused]] GLuint Renderer::Buffer::bufferID() const {
  return bufferID_;
}

void Renderer::Buffer::bind() {
  glBindBuffer(kind_, bufferID_);
}

void Renderer::Buffer::unBind() {
  glBindBuffer(kind_, GL_NONE);
}

void Renderer::Buffer::set(const GLvoid *data, GLsizeiptr size) {
  if (size > size_) {
    size_ = size;
    glBufferData(kind_, size, data, usage_);
  } else {
    glBufferSubData(kind_, 0, size, data);
  }
}
