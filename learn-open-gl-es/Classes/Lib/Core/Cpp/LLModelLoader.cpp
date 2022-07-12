//
//  LLModel.cpp
//  Renderer
//
//  Created by limit on 2022/7/9.
//

#include "LLModelLoader.hpp"
#include <fstream>
#include <vector>

Renderer::ModelLoader::ModelLoader() = default;

Renderer::ModelLoader::~ModelLoader() {
  deletePtr(mesh_);
}

Renderer::ModelLoader::ModelLoader(const std::string &path) {
  init(path);
}

bool Renderer::ModelLoader::initialized() const {
  return initialized_;
}

void Renderer::ModelLoader::init(const std::string &path) {
  std::string file = path + "/tortoise.obj";
  std::ifstream input(file, std::ifstream::in | std::ifstream::binary);
  if (!input.is_open()) {
    std::cerr << "Failed to open file: " << file << std::endl;
  }

  std::vector<glm::vec3> coords;
  std::vector<glm::vec2> texCoords;
  std::vector<glm::vec3> normals;

  std::vector<VertexData> vertices;
  std::vector<GLuint> indexes;

  std::string mtl;
  std::string line;

  while (std::getline(input, line)) {
    std::vector<std::string> list = split(line, " ");
    if (list[0] == "#") {
      std::cout << "Comment: " << line << std::endl;
    } else if (list[0] == "mtllib") {
      std::cout << "Materials: " << list[1] << std::endl;
    } else if (list[0] == "v") {
      coords.emplace_back(glm::vec3(atof(list[1].c_str()), atof(list[2].c_str()), atof(list[3].c_str())));
    } else if (list[0] == "vt") {
      texCoords.emplace_back(glm::vec2(atof(list[1].c_str()), atof(list[2].c_str())));
    } else if (list[0] == "vn") {
      normals.emplace_back(glm::vec3(atof(list[1].c_str()), atof(list[2].c_str()), atof(list[3].c_str())));
    } else if (list[0] == "f") {
      for (int i = 1; i < 4; ++i) {
        std::vector<std::string> vertexArray = split(list[i], "/");
        vertices.emplace_back(
            VertexData(
                coords[static_cast<int>( atol(vertexArray[0].c_str())) - 1],
                texCoords[static_cast<int>( atol(vertexArray[1].c_str())) - 1],
                normals[static_cast<int>( atol(vertexArray[2].c_str())) - 1]
            )
        );
        indexes.emplace_back(static_cast<GLuint>(indexes.size()));
      }
    } else if (list[0] == "usemtl") {
      mtl = list[1];
      std::cout << "MTL Name: " << mtl << std::endl;
    }
  }

  if (mesh_ == nullptr) {
    calculate(vertices);
    mesh_ = new Mesh(path, vertices, indexes);
    vertices.clear();
    indexes.clear();
    initialized_ = mesh_->initialized();
  }
}

[[maybe_unused]] Renderer::Mesh *Renderer::ModelLoader::mesh() const {
  return mesh_;
}

void Renderer::ModelLoader::render(Camera *camera) {
  if (!mesh_) {
    return;
  }
  mesh_->render(camera);
}

void Renderer::ModelLoader::updateTrackingInfo(Camera *camera, glm::vec2 position, float scale) {
  mesh_->updateTrackingInfo(camera, position, scale);
}

void Renderer::ModelLoader::calculate(std::vector<VertexData> &vertexData) {
  for (int i = 0; i < vertexData.size(); i += 3) {
    glm::vec3 &v1 = vertexData[i].position;
    glm::vec3 &v2 = vertexData[i + 1].position;
    glm::vec3 &v3 = vertexData[i + 2].position;

    glm::vec2 &texCoord1 = vertexData[i].texCoord;
    glm::vec2 &texCoord2 = vertexData[i + 1].texCoord;
    glm::vec2 &texCoord3 = vertexData[i + 2].texCoord;

    glm::vec3 deltaPosition1 = v2 - v1;
    glm::vec3 deltaPosition2 = v3 - v1;

    glm::vec2 deltaCoord1 = texCoord2 - texCoord1;
    glm::vec2 deltaCoord2 = texCoord3 - texCoord1;

    float r = 1.0f / (deltaCoord1.x * deltaCoord2.y - deltaCoord1.y * deltaCoord2.x);
    glm::vec3 tangent = (deltaPosition1 * deltaCoord2.y - deltaPosition2 * deltaCoord1.y) * r;
    glm::vec3 bitangent = (deltaPosition2 * deltaCoord1.x - deltaPosition1 * deltaCoord2.x) * r;
    vertexData[i].tangent = tangent;
    vertexData[i + 1].tangent = tangent;
    vertexData[i + 2].tangent = tangent;

    vertexData[i].bitangent = bitangent;
    vertexData[i + 1].bitangent = bitangent;
    vertexData[i + 2].bitangent = bitangent;
  }
}

std::vector<std::string> Renderer::ModelLoader::split(const std::string &src, const std::string &match) {
  std::string::size_type position1, position2;
  size_t len = src.length();
  position2 = src.find(match);
  position1 = 0;
  std::vector<std::string> strings;
  while (std::string::npos != position2) {
    strings.emplace_back(src.substr(position1, position2 - position1));
    position1 = position2 + match.size();
    position2 = src.find(match, position1);
  }
  if (position1 != len) {
    strings.emplace_back(src.substr(position1));
  }
  return strings;
}
