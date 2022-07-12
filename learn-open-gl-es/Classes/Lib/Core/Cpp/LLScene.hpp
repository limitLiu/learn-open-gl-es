//
//  LLScene.hpp
//  Renderer
//
//  Created by limit on 2022/7/3.
//

#ifndef LLScene_hpp
#define LLScene_hpp

#include "common.h"
#include "LLDefine.h"
#include "LLCamera.hpp"
#include "LLYUVideo.hpp"
#include "LLCube.hpp"
#include "LLSticker.hpp"
#include "LLModelLoader.hpp"
#include "LLBuffer.hpp"

namespace Renderer {
using namespace std;
class Scene {
public:
  Scene(string path);
  
  ~Scene();
  
  void render();

  [[maybe_unused]] void resize(GLsizei width, GLsizei height);
  
  void updateYUVFrame(LLYUVFrame *frame);
  
  void updateTrackingInfo(glm::vec2 position, float scale);
  
private:
  void setPath(string path);
  
private:
  string path_;
  
  Camera *camera_;
  
  YUVideo *yuVideo_;
  
  glm::vec2 position_;

  float scale_;
  
  Cube *cube_;
  
  Sticker *sticker_;
  
  ModelLoader *loader_;
  
};
}

#endif /* LLScene_hpp */
