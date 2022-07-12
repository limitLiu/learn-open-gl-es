//
//  LLModel.hpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#ifndef LLModel_hpp
#define LLModel_hpp

#include "LLMesh.hpp"

namespace Renderer {
class ModelLoader {
public:
  explicit ModelLoader();

  virtual ~ModelLoader();

  ModelLoader(const std::string &path);

  void init(const std::string &path);

  [[maybe_unused]] Mesh *mesh() const;

  void render(Camera *camera);

  void updateTrackingInfo(Camera *camera, glm::vec2 position, float scale);

  bool initialized() const;

private:
  void calculate(std::vector<VertexData> &vertexData);

  std::vector<std::string> split(const std::string &src, const std::string &match);

private:
  Mesh *mesh_ = nullptr;
  bool initialized_ = false;

};
}


#endif /* LLModel_hpp */
