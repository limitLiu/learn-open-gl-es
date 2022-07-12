//
//  LLTextureRender.hpp
//  Renderer
//
//  Created by limit on 2022/7/11.
//

#ifndef LLTextureRender_hpp
#define LLTextureRender_hpp

#include "LLModel.h"

namespace Renderer {
class TextureRenderer : public Model {
public:
  TextureRenderer();
  
  TextureRenderer(const std::string &path);
  
  ~TextureRenderer();
  
  void render(Camera *camera, GLuint textureID);
  
  void init(const std::string &path);

private:
  void loadShader();
  
  void setup();
  
};
}

#endif /* LLTextureRender_hpp */
