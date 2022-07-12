//
//  LLVertexArray.cpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#include "LLVertexArray.hpp"

Renderer::VertexArray::VertexArray() {
  glGenVertexArrays(1, &vao_);
}

Renderer::VertexArray::~VertexArray() {
  glDeleteVertexArrays(1, &vao_);
}

void Renderer::VertexArray::bind() {
  glBindVertexArray(vao_);
}

void Renderer::VertexArray::unBind() {
  glBindVertexArray(GL_NONE);
}
