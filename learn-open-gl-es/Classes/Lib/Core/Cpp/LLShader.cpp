//
//  LLShader.cpp
//  Renderer
//
//  Created by limit on 2022/7/4.
//

#include "LLShader.hpp"
#include <fstream>
#include <sstream>

Renderer::Shader::Shader() = default;

Renderer::Shader::~Shader() {
  glDeleteProgram(program_);
}

void Renderer::Shader::bind() {
  glUseProgram(program_);
}

void Renderer::Shader::unBind() {
  glUseProgram(GL_NONE);
}

void Renderer::Shader::set(const char *name, GLfloat x) {
  GLint location = glGetUniformLocation(program_, name);
  glUniform1f(location, x);
}

void Renderer::Shader::set(const char *name, GLint x) {
  GLint location = glGetUniformLocation(program_, name);
  glUniform1i(location, x);
}

void Renderer::Shader::set(const char *name, glm::mat4 mat) {
  GLint location = glGetUniformLocation(program_, name);
  glUniformMatrix4fv(location, 1, GL_FALSE, glm::value_ptr(mat));
}

void Renderer::Shader::set(const char *name, glm::vec2 vec) {
  GLint location = glGetUniformLocation(program_, name);
  glUniform2fv(location, 1, glm::value_ptr(vec));
}

void Renderer::Shader::set(const char *name, glm::vec3 vec) {
  GLint location = glGetUniformLocation(program_, name);
  glUniform3fv(location, 1, glm::value_ptr(vec));
}

void Renderer::Shader::set(const char *name, GLfloat x, GLfloat y, GLfloat z) {
  GLint location = glGetUniformLocation(program_, name);
  glUniform3f(location, x, y, z);
}

[[maybe_unused]] void Renderer::Shader::enableAttributeArray(const char *name) {
  GLuint location = static_cast<GLuint>(glGetAttribLocation(program_, name));
  enableAttributeArray(location);
}

void Renderer::Shader::enableAttributeArray(GLuint location) {
  glEnableVertexAttribArray(location);
}

[[maybe_unused]] void Renderer::Shader::disableAttributeArray(const char *name) {
  GLuint location = static_cast<GLuint>(glGetAttribLocation(program_, name));
  disableAttributeArray(location);
}

void Renderer::Shader::disableAttributeArray(GLuint location) {
  glDisableVertexAttribArray(location);
}

[[maybe_unused]] void Renderer::Shader::setAttribPointer(const char *name, GLint size, GLenum type, GLsizei stride, const GLvoid *ptr) {
  GLuint location = static_cast<GLuint>(glGetAttribLocation(program_, name));
  setAttribPointer(location, size, type, stride, ptr);
}

void Renderer::Shader::setAttribPointer(GLuint location, GLint size, GLenum type, GLsizei stride, const GLvoid *ptr) {
  glVertexAttribPointer(location, size, type, GL_FALSE, stride, ptr);
}

Renderer::Shader::Shader(const std::string &vertexShader, const std::string &fragmentShader) {
  init(vertexShader, fragmentShader);
}

bool Renderer::Shader::initialized() const {
  return initialized_;
}

void Renderer::Shader::init(const std::string &vertexShader, const std::string &fragmentShader) {
  GLuint vertex{};
  GLuint fragment{};

  if (vertexShader.empty() || fragmentShader.empty()) {
    return;
  }

  auto isCompileV = compile(vertex, GL_VERTEX_SHADER, vertexShader);
  auto isCompileS = compile(fragment, GL_FRAGMENT_SHADER, fragmentShader);
  if (isCompileV && isCompileS) {
    GLuint program = glCreateProgram();

    glAttachShader(program, vertex);
    glAttachShader(program, fragment);
    auto linked = link(program);
    glDetachShader(program, vertex);
    glDeleteShader(vertex);
    glDetachShader(program, fragment);
    glDeleteShader(fragment);
    if (!linked) {
      std::cout << "Failed to link program:\n" << program << std::endl;
      glDeleteProgram(program);
    }
    program_ = program;
    initialized_ = true;
  }
}

bool Renderer::Shader::compile(GLuint &shader, GLenum type, const std::string &fileName) {
  std::ifstream shaderFile;
  std::stringstream fileStream;
  shaderFile.exceptions(std::ifstream::failbit | std::ifstream::badbit);
  std::string content;
  try {
    shaderFile.open(fileName);
    if (!shaderFile.is_open()) {
      throw "Failed to open file";
    }
    fileStream << shaderFile.rdbuf();
    shaderFile.close();
    content = fileStream.str();
  } catch (const char *error) {
    std::cout << error;
  }

  auto src = content.c_str();
  shader = glCreateShader(type);
  glShaderSource(shader, 1, &src, nullptr);
  glCompileShader(shader);

  GLint logLen, status;
  glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &logLen);
  if (logLen > 0) {
    GLchar *log = (GLchar *) malloc((size_t) logLen);
    glGetShaderInfoLog(shader, logLen, &logLen, log);
    std::cout << "shader compile log:\n" << log << std::endl;
    free(log);
  }
  glGetShaderiv(shader, GL_COMPILE_STATUS, &status);
  if (status == 0) {
    glDeleteShader(shader);
    return false;
  }
  return true;
}

bool Renderer::Shader::link(GLuint program) {
  glLinkProgram(program);
  GLint logLen, status;
  glGetProgramiv(program, GL_INFO_LOG_LENGTH, &logLen);
  if (logLen > 0) {
    GLchar *log = (GLchar *) malloc((size_t) logLen);
    glGetProgramInfoLog(program, logLen, &logLen, log);
    std::cout << "program link log:\n" << log << std::endl;
    free(log);
  }
  glGetProgramiv(program, GL_LINK_STATUS, &status);
  return status != 0;
}
