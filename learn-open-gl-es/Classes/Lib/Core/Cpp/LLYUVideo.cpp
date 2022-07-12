//
//  LLYUVideo.cpp
//  Renderer
//
//  Created by limit on 2022/7/5.
//

#include "LLYUVideo.hpp"

Renderer::YUVideo::YUVideo(const std::string &path) {
  path_ = path;
  glGenTextures(3, textures_);
  if (!path_.empty()) {
    auto vertexShaderFile = path_ + "/yuv.vert";
    auto fragmentShaderFile = path_ + "/yuv.frag";
    shader_ = new Shader(vertexShaderFile, fragmentShaderFile);
  }
}

Renderer::YUVideo::~YUVideo() {
  deletePtr(shader_);
  glDeleteTextures(3, textures_);
  freeBuffer(buffer_);
}

void Renderer::YUVideo::freeBuffer(uint8_t *buffer) {
  if (nullptr != buffer) {
    free(buffer);
    buffer = nullptr;
  }
}

void Renderer::YUVideo::updateYUVFrame(LLYUVFrame *frame) {
  if (frame == nullptr) {
    return;
  }
  if (videoWidth_ != frame->width || videoHeight_ != frame->height) {
    freeBuffer(buffer_);
  }
  videoWidth_ = frame->width;
  videoHeight_ = frame->height;
  yLen_ = frame->luma.length;
  uLen_ = frame->chromaB.length;
  vLen_ = frame->chromaR.length;
  size_t yuvLen = yLen_ + uLen_ + vLen_;

  if (nullptr == buffer_) {
    buffer_ = (uint8_t *) malloc(yuvLen);
  }
  memcpy(buffer_, frame->luma.data, yLen_);
  memcpy(buffer_ + yLen_, frame->chromaB.data, uLen_);
  memcpy(buffer_ + yLen_ + uLen_, frame->chromaR.data, vLen_);

  updated_ = true;
}

void Renderer::YUVideo::render(Camera *camera) {
  if (!updated_) {
    return;
  }

  static LLVertex vertices[] = {
      {-1, 1, 0, 0, 0},
      {-1, -1, 0, 0, 1},
      {1, 1, 0, 1, 0},
      {1, -1, 0, 1, 1},
  };
  auto objectMat = glm::mat4x4(1.0);
  auto translateMat = glm::translate(glm::mat4(1.0), glm::vec3(0.0, 0.0, -5.0));
  objectMat = objectMat * translateMat;
  objectMat = camera->projectionMat * camera->viewMat * objectMat;
  shader_->bind();
  shader_->set("uMat", objectMat);
  GLuint aPosition = 0;
  shader_->enableAttributeArray(aPosition);
  GLuint aTexCoord = 1;
  shader_->enableAttributeArray(aTexCoord);

  shader_->setAttribPointer(aPosition, 3, GL_FLOAT, sizeof(LLVertex), vertices);
  shader_->setAttribPointer(aTexCoord, 2, GL_FLOAT, sizeof(LLVertex), &vertices[0].u);

  shader_->set("uTextureY", 0);
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, textures_[0]);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, videoWidth_, videoHeight_, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, buffer_);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  shader_->set("uTextureU", 1);
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, textures_[1]);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, videoWidth_ / 2, videoHeight_ / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, buffer_ + yLen_);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  shader_->set("uTextureV", 2);
  glActiveTexture(GL_TEXTURE2);
  glBindTexture(GL_TEXTURE_2D, textures_[2]);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_LUMINANCE, videoWidth_ / 2, videoHeight_ / 2, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, buffer_ + yLen_ + uLen_);
  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

  glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  shader_->disableAttributeArray(aPosition);
  shader_->disableAttributeArray(aTexCoord);
  shader_->unBind();
}
