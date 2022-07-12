//
//  LLSticker.hpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#ifndef LLSticker_hpp
#define LLSticker_hpp

#include "LLModel.h"

namespace Renderer {
class Sticker : public Model {
public:
  Sticker();

  Sticker(const std::string &path);

  ~Sticker();

  void render(Camera *camera);

  void updateTrackingInfo(Camera *camera, glm::vec2 position, float scale);

  void init(const std::string &path);

private:
  void loadShader();

  void loadTextures();

  void setup();
  
private:
  GLuint textureID_;

  float x_ = 0.0;

  float y_ = 0.0;

  float z_ = -3.0f;

  float scale_ = 1.0;
};
}

#endif /* LLSticker_hpp */
