//
//  LLCamera.hpp
//  Renderer
//
//  Created by limit on 2022/7/4.
//

#ifndef LLCamera_hpp
#define LLCamera_hpp

#include "common.h"

namespace Renderer {
class Camera {
public:
  Camera();

  ~Camera();

  [[maybe_unused]] glm::vec3 eye() const;

public:
  glm::mat4x4 viewMat;

  glm::mat4x4 projectionMat;

private:
  glm::vec3 eye_ = glm::vec3(0, 0, 1);
  glm::vec3 center_ = glm::vec3(0, 0, 0);
  glm::vec3 up_ = glm::vec3(0, 1, 0);
};
}

#endif /* LLCamera_hpp */
