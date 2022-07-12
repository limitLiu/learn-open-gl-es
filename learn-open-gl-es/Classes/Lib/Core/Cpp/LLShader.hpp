//
//  LLShader.hpp
//  Renderer
//
//  Created by limit on 2022/7/4.
//

#ifndef LLShader_hpp
#define LLShader_hpp

#include "common.h"

namespace Renderer {
class Shader {
public:
  Shader();

  Shader(const std::string &vertexShader, const std::string &fragmentShader);

  ~Shader();

  void init(const std::string &vertexShader, const std::string &fragmentShader);

  void bind();

  void unBind();

  void set(const char *name, GLfloat x);

  void set(const char *name, GLint x);

  void set(const char *name, glm::mat4 mat);

  void set(const char *name, glm::vec2 vec);

  void set(const char *name, glm::vec3 vec);

  void set(const char *name, GLfloat x, GLfloat y, GLfloat z);

  [[maybe_unused]] void enableAttributeArray(const char *name);

  void enableAttributeArray(GLuint location);

  [[maybe_unused]] void disableAttributeArray(const char *name);

  void disableAttributeArray(GLuint location);

  [[maybe_unused]] void setAttribPointer(const char *name, GLint size, GLenum type, GLsizei stride, const GLvoid *ptr);

  void setAttribPointer(GLuint location, GLint size, GLenum type, GLsizei stride, const GLvoid *ptr);

  bool initialized() const;

private:
  bool compile(GLuint &shader, GLenum type, const std::string &fileName);

  bool link(GLuint program);

  GLuint program_{};

  bool initialized_ = false;

};
}

#endif /* LLShader_hpp */
