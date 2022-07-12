//
//  LLCamera.cpp
//  Renderer
//
//  Created by limit on 2022/7/4.
//

#include "LLCamera.hpp"

Renderer::Camera::Camera() {
  viewMat = glm::mat4x4(1.0);
  projectionMat = glm::mat4x4(1.0);
  projectionMat = glm::ortho(-0.83, 0.83, -1.0, 1.0, 0.1, 1000.0);
  viewMat = glm::lookAt(eye_, center_, up_);
}

Renderer::Camera::~Camera() = default;

[[maybe_unused]] glm::vec3 Renderer::Camera::eye() const {
  return eye_;
}
