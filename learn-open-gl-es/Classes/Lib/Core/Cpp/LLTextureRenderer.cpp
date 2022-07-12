//
//  LLTextureRender.cpp
//  Renderer
//
//  Created by limit on 2022/7/11.
//

#include "LLTextureRenderer.hpp"
#include "LLDefine.h"

Renderer::TextureRenderer::TextureRenderer() {
  constructor();
}

Renderer::TextureRenderer::TextureRenderer(const std::string &path) {
  constructor();
  init(path);
}

Renderer::TextureRenderer::~TextureRenderer() {
  release();
}

void Renderer::TextureRenderer::render(Camera *camera, GLuint textureID) {
  glm::mat4x4 objectMat = glm::mat4x4(1.0);
  glm::mat4x4 translateMat = glm::translate(glm::mat4(1.0), glm::vec3(0.0, 0.0, -2.0));
  objectMat = camera->projectionMat * camera->viewMat * translateMat;
  shader()->bind();
  shader()->set("uMat", objectMat);
  vao()->bind();
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, textureID);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (const short *) 0);
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  shader()->unBind();
  vao()->unBind();
}

void Renderer::TextureRenderer::init(const std::string &path) {
  setPath(path);
  if (!path.empty()) {
    loadShader();
  }
  setup();
  setInitialized(true);
}

void Renderer::TextureRenderer::setup() {
  if (shader() == nullptr) {
    return;
  }
  
  const LLVertex vertices[] = {
    {-1.0f, -1.0f, 0.0, 0.0, 0.0},
    {-1.0f,  1.0, 0.0, 0.0, 1.0},
    { 1.0, -1.0f, 0.0, 1.0, 0.0},
    { 1.0,  1.0, 0.0, 1.0, 1.0},
  };
  const short indexes[] = {
    0, 1, 2, 1, 3, 2,
  };
  vao()->bind();
  vbo()->bind();
  vbo()->set(vertices, sizeof(vertices));
  
  ebo()->bind();
  ebo()->set(indexes, sizeof(indexes));
  GLuint aPosition = 0;
  shader()->setAttribPointer(aPosition, 3, GL_FLOAT, sizeof(LLVertex), (void *) 0);
  shader()->enableAttributeArray(aPosition);
  
  GLuint aUV = 1;
  shader()->setAttribPointer(aUV, 2, GL_FLOAT, sizeof(LLVertex), (void *) (3 * sizeof(float)));
  shader()->enableAttributeArray(aUV);
  
  vao()->unBind();
  vbo()->unBind();
  ebo()->unBind();
}

void Renderer::TextureRenderer::loadShader() {
  if (!shader()->initialized()) {
    auto vertexShader = path() + "/texture.vert";
    auto fragmentShader = path() + "/texture.frag";
    shader()->init(vertexShader, fragmentShader);
  }
}
