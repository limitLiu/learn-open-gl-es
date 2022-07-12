//
//  LLScene.cpp
//  Renderer
//
//  Created by limit on 2022/7/3.
//

#include "LLScene.hpp"

Renderer::Scene:: Scene(string path) {
  glClearColor(0.0, 0.0, 0.0, 1.0);
  glClearDepthf(1.0);
  glEnable(GL_DEPTH_TEST);
  glDepthFunc(GL_LEQUAL);
  camera_ = new Camera();
  setPath(path);
  
  yuVideo_ = new YUVideo(path_);
  cube_ = new Cube();
  sticker_ = new Sticker(path_);
  loader_ = new ModelLoader(path_);
}

Renderer::Scene::~Scene() {
  deletePtr(camera_);
  deletePtr(yuVideo_);
  deletePtr(cube_);
  deletePtr(sticker_);
}

void Renderer::Scene::render() {
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  yuVideo_->render(camera_);
  if (cube_->initialized()) {
    cube_->render(camera_);
  } else {
    cube_->init(path_);
    cube_->render(camera_);
  }
  sticker_->render(camera_);
  sticker_->updateTrackingInfo(camera_, position_, scale_);
  if (loader_->initialized()) {
    loader_->render(camera_);
    loader_->updateTrackingInfo(camera_, position_, scale_);
  }
}

void Renderer::Scene::setPath(std::string path) {
  path_ = path;
}

void Renderer::Scene::updateYUVFrame(LLYUVFrame *frame) {
  yuVideo_->updateYUVFrame(frame);
}

void Renderer::Scene::updateTrackingInfo(glm::vec2 position, float scale) {
  position_ = position;
  scale_ = scale;
}

[[maybe_unused]] void Renderer::Scene::resize(GLsizei width, GLsizei height) {
  glViewport(0, 0, width, height);
}
