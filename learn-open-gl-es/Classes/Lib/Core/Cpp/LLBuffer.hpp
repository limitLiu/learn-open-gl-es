//
//  LLBuffer.hpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#ifndef LLBuffer_hpp
#define LLBuffer_hpp

#include "common.h"

namespace Renderer {
class Buffer {
public:
  enum Kind {
    VertexBuffer [[maybe_unused]] = GL_ARRAY_BUFFER,
    IndexBuffer [[maybe_unused]] = GL_ELEMENT_ARRAY_BUFFER,
    PixelPackBuffer [[maybe_unused]] = GL_PIXEL_PACK_BUFFER,
    PixelUnpackBuffer [[maybe_unused]] = GL_PIXEL_UNPACK_BUFFER,
  };
  enum UsagePattern {
    StreamDraw [[maybe_unused]] = GL_STREAM_DRAW,
    StreamRead [[maybe_unused]] = GL_STREAM_READ,
    StreamCopy [[maybe_unused]] = GL_STREAM_COPY,
    StaticDraw [[maybe_unused]] = GL_STATIC_DRAW,
    StaticRead [[maybe_unused]] = GL_STATIC_READ,
    StaticCopy [[maybe_unused]] = GL_STATIC_COPY,
    DynamicDraw [[maybe_unused]] = GL_DYNAMIC_DRAW,
    DynamicRead [[maybe_unused]] = GL_DYNAMIC_READ,
    DynamicCopy [[maybe_unused]] = GL_DYNAMIC_COPY,
  };

  Buffer(Kind kind, UsagePattern usage);

  ~Buffer();

  void bind();

  void unBind();

  [[maybe_unused]] GLuint bufferID() const;

  void set(const GLvoid *data, GLsizeiptr size);

private:
  Kind kind_;
  GLsizeiptr size_;
  GLuint bufferID_;
  UsagePattern usage_;
};
}

#endif /* LLBuffer_hpp */
