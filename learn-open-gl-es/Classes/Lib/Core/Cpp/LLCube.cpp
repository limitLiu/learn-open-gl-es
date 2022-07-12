//
//  LLCube.cpp
//  Renderer
//
//  Created by limit on 2022/7/8.
//

#include "LLCube.hpp"
#include "LLTexture.hpp"
#include "LLDefine.h"

Renderer::Cube::Cube() {
  constructor();
}

[[maybe_unused]] Renderer::Cube::Cube(const std::string &path) {
  constructor();
  init(path);
}

void Renderer::Cube::init(const std::string &path) {
  setPath(path);
  if (!path.empty()) {
    loadShader();
    loadTextures();
  }
  setup();
  setInitialized(true);
}

Renderer::Cube::~Cube() {
  glDeleteTextures(6, textures_);
  release();
}

void Renderer::Cube::setup() {
  if (shader() == nullptr) {
    return;
  }
  const LLVertex cubes[] = {
      {-1.0f, -1.0f, 1.0, 0.0, 0.0},
      {-1.0f, 1.0, 1.0, 0.0, 1.0},
      {1.0, -1.0f, 1.0, 1.0, 0.0},
      {1.0, 1.0, 1.0, 1.0, 1.0},

      {1.0, -1.0f, -1.0f, 0.0, 0.0},
      {1.0, 1.0, -1.0f, 0.0, 1.0},
      {-1.0f, -1.0f, -1.0f, 1.0, 0.0},
      {-1.0f, 1.0, -1.0f, 1.0, 1.0},

      {-1.0f, -1.0f, -1.0f, 0.0, 0.0},
      {-1.0f, 1.0, -1.0f, 0.0, 1.0},
      {-1.0f, -1.0f, 1.0, 1.0, 0.0},
      {-1.0f, 1.0, 1.0, 1.0, 1.0},

      {1.0, -1.0f, 1.0, 0.0, 0.0},
      {1.0, 1.0, 1.0, 0.0, 1.0},
      {1.0, -1.0f, -1.0f, 1.0, 0.0},
      {1.0, 1.0, -1.0f, 1.0, 1.0},

      {-1.0f, 1.0, 1.0, 0.0, 0.0},
      {-1.0f, 1.0, -1.0f, 0.0, 1.0},
      {1.0, 1.0, 1.0, 1.0, 0.0},
      {1.0, 1.0, -1.0f, 1.0, 1.0},

      {-1.0f, -1.0f, -1.0f, 0.0, 0.0},
      {-1.0f, -1.0f, 1.0, 0.0, 1.0},
      {1.0, -1.0f, -1.0f, 1.0, 0.0},
      {1.0, -1.0f, 1.0, 1.0, 1.0}
  };
  const short cubeIndexes[] = {
      0, 1, 2, 2, 1, 3,
      4, 5, 6, 6, 5, 7,
      8, 9, 10, 10, 9, 11,
      12, 13, 14, 14, 13, 15,
      16, 17, 18, 18, 17, 19,
      20, 21, 22, 22, 21, 23,
  };

  vao()->bind();
  vbo()->bind();
  vbo()->set(cubes, sizeof(cubes));

  ebo()->bind();
  ebo()->set(cubeIndexes, sizeof(cubeIndexes));

  GLuint aPosition = 0;
  shader()->setAttribPointer(aPosition, 3, GL_FLOAT, sizeof(LLVertex), (void *) 0);
  shader()->enableAttributeArray(aPosition);

  GLuint aUV = 1;
  shader()->setAttribPointer(aUV, 2, GL_FLOAT, sizeof(LLVertex), (void *) (3 * sizeof(float)));
  shader()->enableAttributeArray(aUV);

  vao()->unBind();
  vbo()->unBind();
  ebo()->unBind();
}

void Renderer::Cube::loadTextures() {
  auto texturesPath = path() + "/" + RENDERER_TEXTURE_PATH;
  for (int i = 0; i < 6; ++i) {
    auto name = (i + 1) % 2 == 0 ? "awesomeface.png" : "container.jpg";
    textures_[i] = LLTexture::fromFile(texturesPath, name);
  }
}

void Renderer::Cube::render(Camera *camera) {
  glCullFace(GL_BACK);
  glFrontFace(GL_CW);

  angle_ += 0.05;

  auto objectMat = glm::mat4x4(1.0);
  auto translateMat = glm::translate(glm::mat4(1.0), glm::vec3(0.0, 0.0, -4.0));
  auto rotateMat = glm::rotate(glm::mat4(1.0), angle_, glm::vec3(1.0, 1.0, 1.0));
  auto scaleMat = glm::scale(glm::mat4(1.0), glm::vec3(0.3, 0.2, 0.3));
  objectMat = camera->projectionMat * camera->viewMat * translateMat * scaleMat * rotateMat;
  shader()->bind();
  shader()->set("uMat", objectMat);
  vao()->bind();
  for (int i = 0; i < 6; ++i) {
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, textures_[i]);

    const short *indices = (const short *) (i * 6 * sizeof(short));
    glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, indices);
    glBindTexture(GL_TEXTURE_2D, GL_NONE);
  }
  shader()->unBind();
  vao()->unBind();
}

void Renderer::Cube::loadShader() {
  if (!shader()->initialized()) {
    auto vertexShader = path() + "/cube.vert";
    auto fragmentShader = path() + "/cube.frag";
    shader()->init(vertexShader, fragmentShader);
  }
}
