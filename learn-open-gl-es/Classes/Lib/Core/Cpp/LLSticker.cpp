//
//  LLSticker.cpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#include "LLSticker.hpp"
#include "LLTexture.hpp"
#include "LLDefine.h"

Renderer::Sticker::Sticker(const std::string &path) {
  constructor();
  init(path);
}

Renderer::Sticker::~Sticker() {
  glDeleteTextures(1, &textureID_);
  release();
}

void Renderer::Sticker::render(Camera *camera) {
  glm::mat4x4 objectMat = glm::mat4x4(1.0);
  glm::mat4x4 translateMat = glm::translate(glm::mat4(1.0), glm::vec3(x_, y_ + 0.2, z_));
  glm::mat4x4 scaleMat = glm::scale(glm::mat4(1.0), glm::vec3(0.4 * scale_, 0.4 * 0.6 * scale_, 1.0));
  objectMat = camera->projectionMat * camera->viewMat * translateMat * scaleMat;
  shader()->bind();
  shader()->set("uMat", objectMat);
  vao()->bind();
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, textureID_);
  glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (const short *) 0);
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  shader()->unBind();
  vao()->unBind();
}

void Renderer::Sticker::setup() {
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

void Renderer::Sticker::loadTextures() {
  auto texturesPath = path() + "/" + RENDERER_TEXTURE_PATH;
  textureID_ = LLTexture::fromFile(texturesPath, "awesomeface.png");
}

void Renderer::Sticker::updateTrackingInfo(Camera *camera, glm::vec2 position, float scale) {
  x_ = position.x;
  y_ = position.y;
  scale_ = scale;
  GLint viewport[] = { 0, 0, 0, 0 };
  GLfloat z = 0;
  glGetIntegerv(GL_VIEWPORT, viewport);
  GLfloat x = static_cast<GLfloat>(position.x * viewport[2] / 1080.0);
  GLfloat y = static_cast<GLfloat>(position.y * viewport[3] / 1920.0);
  
//  glReadBuffer(GL_FRONT);
//  glReadPixels(x, viewport[3] - y, 1, 1, GL_DEPTH_COMPONENT, GL_FLOAT, &z_);
  auto vec = glm::unProject(glm::vec3(x, viewport[3] - y, z), camera->viewMat, camera->projectionMat, glm::vec4(0, 0, viewport[2], viewport[3]));
  x_ = vec.x;
  y_ = vec.y;
}

Renderer::Sticker::Sticker() {
  constructor();
}

void Renderer::Sticker::init(const std::string &path) {
  setPath(path);
  if (!path.empty()) {
    loadShader();
    loadTextures();
  }
  setup();
  setInitialized(true);
}

void Renderer::Sticker::loadShader() {
  if (!shader()->initialized()) {
    auto vertexShader = path() + "/sticker.vert";
    auto fragmentShader = path() + "/sticker.frag";
    shader()->init(vertexShader, fragmentShader);
  }
}
