//
//  LLYUVideo.hpp
//  Renderer
//
//  Created by limit on 2022/7/5.
//

#ifndef LLYUVideo_hpp
#define LLYUVideo_hpp

#include "common.h"
#include "LLShader.hpp"
#include "LLCamera.hpp"
#include "LLDefine.h"

namespace Renderer {
class YUVideo {
public:
  YUVideo(const std::string &path);
  
  ~YUVideo();
  
  void render(Camera *camera);
  
  void updateYUVFrame(LLYUVFrame *frame);
  
private:
  void freeBuffer(uint8_t *buffer);
  
  std::string path_;
  
  Shader *shader_;
  
  GLuint textures_[3];
  
  GLsizei videoWidth_;
  
  GLsizei videoHeight_;
  
  size_t yLen_;
  
  size_t uLen_;
  
  size_t vLen_;
  
  uint8_t *buffer_ = nullptr;
  
  bool updated_ = false;
};
}

#endif /* LLYUVideo_hpp */
