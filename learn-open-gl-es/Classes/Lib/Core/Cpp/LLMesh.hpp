//
//  LLMesh.hpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#ifndef LLMesh_hpp
#define LLMesh_hpp

#include "LLModel.h"

namespace Renderer {
struct VertexData {
  VertexData() = default;
  VertexData(glm::vec3 position, glm::vec2 texCoord, glm::vec3 normal): position(position), texCoord(texCoord), normal(normal) {
  }
  glm::vec3 position;
  glm::vec2 texCoord;
  glm::vec3 normal;
  glm::vec3 tangent;
  glm::vec3 bitangent;
};

class Mesh : public Model {
public:
  Mesh();

  Mesh(const std::string &path, const std::vector<VertexData> &vertexData, const std::vector<GLuint> &indexes);

  ~Mesh();

  void render(Camera *camera);

  void updateTrackingInfo(Camera *camera, glm::vec2 position, float scale);

  void init(const std::string &path, const std::vector<VertexData> &vertexData, const std::vector<GLuint> &indexes);

private:
  void loadShader();
  void loadTextures();

private:
  float x_ = 0;
  
  float y_ = 0;
  
  float z_ = -1;
  
  float scale_ = 1.0;
  
  size_t size_ = 0;
  
  GLuint diffuseID_;
  
  GLuint normalID_;
  
  GLuint specularID_;
  
};
}

#endif /* LLMesh_hpp */
