//
//  LLVertexArray.hpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#ifndef LLVertexArray_hpp
#define LLVertexArray_hpp

#include "common.h"

namespace Renderer {
class VertexArray {
public:
  VertexArray();

  ~VertexArray();

  void bind();

  void unBind();

private:
  GLuint vao_;
};
}

#endif /* LLVertexArray_hpp */
