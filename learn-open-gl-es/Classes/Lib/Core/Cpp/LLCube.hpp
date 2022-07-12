//
//  LLCube.hpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#ifndef LLCube_hpp
#define LLCube_hpp

#include "LLModel.h"

namespace Renderer {
class Cube : public Model {
public:
  Cube();

  [[maybe_unused]] Cube(const std::string &path);

  ~Cube();

  void render(Camera *camera);

  void init(const std::string &path);

private:
  void loadShader();

  void loadTextures();

  void setup();

private:
  float angle_ = 0.0f;

  GLuint textures_[6];
};
}

#endif /* LLCube_hpp */
