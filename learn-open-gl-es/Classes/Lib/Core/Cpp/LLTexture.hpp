//
//  LLTexture.hpp
//  Renderer
//
//  Created by limit on 2022/7/7.
//

#ifndef LLTexture_hpp
#define LLTexture_hpp

#include "common.h"
#include "LLImage.hpp"

namespace LLTexture {
static GLuint create(std::shared_ptr<Renderer::Image> image) {
  GLuint textureID;
  glEnable(GL_TEXTURE_2D);
  glGenTextures(1, &textureID);
  glBindTexture(GL_TEXTURE_2D, textureID);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
  glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, image->width(), image->height(), 0, GL_RGBA, GL_UNSIGNED_BYTE, image->data());
  return textureID;
}

static GLuint generate(const std::string &path, const std::string &fileName) {
  std::string imageFile = path + "/" + fileName;
  auto image = std::make_shared<Renderer::Image>();
  image->from(imageFile.c_str());
  GLuint textureID = create(image);
  return textureID;
}

inline GLuint fromFile(const std::string &path, const std::string &fileName) {
  return generate(path, fileName);
}
}

#endif /* LLTexture_hpp */
