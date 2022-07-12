//
//  LLMesh.cpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#include "LLMesh.hpp"
#include "LLTexture.hpp"
#include <vector>

Renderer::Mesh::Mesh() {
  constructor();
}

Renderer::Mesh::Mesh(const std::string &path, const std::vector<VertexData> &vertexData, const std::vector<GLuint> &indexes) {
  constructor();
  init(path, vertexData, indexes);
}

Renderer::Mesh::~Mesh() {
  glDeleteTextures(1, &diffuseID_);
  glDeleteTextures(1, &normalID_);
  glDeleteTextures(1, &specularID_);
  release();
}

void Renderer::Mesh::render(Renderer::Camera *camera) {
  auto modelMat = glm::mat4x4(1.0);
  auto translateMat = glm::translate(glm::mat4(1.0f), glm::vec3(x_, y_, z_));
  auto scaleMat = glm::scale(glm::mat4(1.0f), glm::vec3(0.25f * scale_, 0.25f * 0.6 * scale_, 0.25f * scale_));
  modelMat = translateMat * scaleMat;
  shader()->bind();
  shader()->set("uModelMat", modelMat);
  shader()->set("uViewMat", camera->viewMat);
  shader()->set("uProjectionMat", camera->projectionMat);
  
  glActiveTexture(GL_TEXTURE0);
  glBindTexture(GL_TEXTURE_2D, diffuseID_);
  shader()->set("textureDiffuse", 0);
  
  glActiveTexture(GL_TEXTURE1);
  glBindTexture(GL_TEXTURE_2D, normalID_);
  shader()->set("textureNormal", 1);
  
  glActiveTexture(GL_TEXTURE2);
  glBindTexture(GL_TEXTURE_2D, specularID_);
  shader()->set("textureSpecular", 2);
  
  shader()->set("uShine", 32.0f);
  shader()->set("uViewPosition", camera->eye());
  
  shader()->set("light.ambient", glm::vec3(0.5, 0.5, 0.5));
  shader()->set("light.diffuse", glm::vec3(0.8, 0.8, 0.8));
  shader()->set("light.specular", glm::vec3(0.9, 0.9, 0.9));
  
  shader()->set("light.position", glm::vec3(5.0, 5.0, 5.0));
  shader()->set("light.c", 1.0f);
  shader()->set("light.l", 0.09f);
  shader()->set("light.q", 0.032f);
  
  vao()->bind();
  glDrawElements(GL_TRIANGLES, (GLsizei) size_, GL_UNSIGNED_INT, (const int *) 0);
  glBindTexture(GL_TEXTURE_2D, GL_NONE);
  shader()->unBind();
  vao()->unBind();
}

void Renderer::Mesh::init(const std::string &path, const std::vector<VertexData> &vertexData, const std::vector<GLuint> &indexes) {
  if (path.empty()) {
    return;
  }
  setPath(path);
  loadShader();
  loadTextures();
  
  size_ = indexes.size();
  
  vao()->bind();
  vbo()->bind();
  vbo()->set(vertexData.data(), vertexData.size() * sizeof(VertexData));
  ebo()->bind();
  ebo()->set(indexes.data(), indexes.size() * sizeof(GLuint));
  
  size_t offset = 0;
  GLuint aPosition = 0;
  shader()->setAttribPointer(aPosition, 3, GL_FLOAT, sizeof(VertexData), (void *) offset);
  shader()->enableAttributeArray(aPosition);
  
  offset += sizeof(glm::vec3);
  GLuint aTexCoord = 1;
  shader()->setAttribPointer(aTexCoord, 2, GL_FLOAT, sizeof(VertexData), (void *) offset);
  shader()->enableAttributeArray(aTexCoord);
  
  
  offset += sizeof(glm::vec2);
  GLuint aNormal = 2;
  shader()->setAttribPointer(aNormal, 3, GL_FLOAT, sizeof(VertexData), (void *) offset);
  shader()->enableAttributeArray(aNormal);
  
  offset += sizeof(glm::vec3);
  GLuint aTangent = 3;
  shader()->setAttribPointer(aTangent, 3, GL_FLOAT, sizeof(VertexData), (void *) offset);
  shader()->enableAttributeArray(aTangent);
  
  offset += sizeof(glm::vec3);
  GLuint aBitangent = 4;
  shader()->setAttribPointer(aBitangent, 3, GL_FLOAT, sizeof(VertexData), (void *) offset);
  shader()->enableAttributeArray(aBitangent);
  
  vao()->unBind();
  vbo()->unBind();
  ebo()->unBind();
  setInitialized(true);
}

void Renderer::Mesh::updateTrackingInfo(Renderer::Camera *camera, glm::vec2 position, float scale) {
  x_ = position.x;
  y_ = position.y;
  scale_ = scale;
  GLint viewport[] = { 0, 0, 0, 0 };
  GLfloat z = 0;
  glGetIntegerv(GL_VIEWPORT, viewport);
  GLfloat x = static_cast<GLfloat>(position.x * viewport[2] / 1080.0);
  GLfloat y = static_cast<GLfloat>(position.y * viewport[3] / 1920.0);
  
  glm::vec3 mat = glm::unProject(glm::vec3(x, viewport[3] - y, z), camera->viewMat, camera->projectionMat, glm::vec4(0, 0, viewport[2], viewport[3]));
  x_ = mat.x;
  y_ = mat.y;
}

void Renderer::Mesh::loadShader() {
  if (!shader()->initialized()) {
    auto vertexShader = path() + "/obj.vert";
    auto fragmentShader = path() + "/obj.frag";
    shader()->init(vertexShader, fragmentShader);
  }
}

void Renderer::Mesh::loadTextures() {
  auto texturesPath = path() + "/" + RENDERER_TEXTURE_PATH;
  diffuseID_ = LLTexture::fromFile(texturesPath, "tortoise_diffuse.png");
  normalID_ = LLTexture::fromFile(texturesPath, "tortoise_normal.png");
  specularID_ = LLTexture::fromFile(texturesPath, "tortoise_specular.png");
}
