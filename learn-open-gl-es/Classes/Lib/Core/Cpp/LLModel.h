//
//  LLModel.h
//  Model
//
//  Created by limit on 2022/7/9.
//

#ifndef LLModel_h
#define LLModel_h

#include "common.h"
#include "LLCamera.hpp"
#include "LLVertexArray.hpp"
#include "LLBuffer.hpp"
#include "LLShader.hpp"

namespace Renderer {

class Model {
public:
  void setInitialized(bool initialized) {
    initialized_ = initialized;
  }

  bool initialized() const {
    return initialized_;
  };

  void setVAO(VertexArray *vao) {
    vao_ = vao;
  }

  VertexArray *vao() const {
    return vao_;
  }

  void setVBO(Buffer *vbo) {
    vbo_ = vbo;
  }

  Buffer *vbo() const {
    return vbo_;
  }

  void setEBO(Buffer *ebo) {
    ebo_ = ebo;
  }

  Buffer *ebo() const {
    return ebo_;
  }

  void setShader(Shader *shader) {
    shader_ = shader;
  }

  Shader *shader() const {
    return shader_;
  }

  std::string path() const {
    return path_;
  }

  void setPath(const std::string &path) {
    path_ = path;
  }

protected:
  void constructor() {
    auto vao = new VertexArray();
    auto vbo = new Buffer(Buffer::VertexBuffer, Buffer::StaticDraw);
    auto ebo = new Buffer(Buffer::IndexBuffer, Buffer::StaticDraw);
    auto shader = new Shader();
    setVAO(vao);
    setVBO(vbo);
    setEBO(ebo);
    setShader(shader);
  }

  void release() {
    deletePtr(vao_);
    deletePtr(vbo_);
    deletePtr(ebo_);
    deletePtr(shader_);
  }

private:
  virtual void loadShader() = 0;

private:
  bool initialized_ = false;

  std::string path_;

  VertexArray *vao_;

  Buffer *vbo_;

  Buffer *ebo_;

  Shader *shader_;
};
}


#endif /* LLModel_h */
