//
//  common.h
//  Renderer
//
//  Created by limit on 2022/7/3.
//

#ifndef common_h
#define common_h

#include <iostream>
#include <OpenGLES/ES3/glext.h>
#include <glm/vec3.hpp>
#include <glm/vec4.hpp>
#include <glm/glm.hpp>
#include <glm/mat4x4.hpp>
#include <glm/gtc/type_ptr.hpp>
#include <glm/ext/matrix_transform.hpp>
#include <glm/ext/matrix_clip_space.hpp>

#define RENDERER_TEXTURE_PATH "textures.bundle"

template<typename T>
void deletePtr(T *ptr) {
  if (ptr != nullptr) {
    delete ptr;
    ptr = nullptr;
  }
}

#endif /* common_h */
