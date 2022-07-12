//
//  LLImage.hpp
//  Renderer
//
//  Created by limit on 2022/7/7.
//

#ifndef LLImage_hpp
#define LLImage_hpp

namespace Renderer {
class Image {
public:
  Image();

  ~Image();

  int width() const;

  int height() const;

  unsigned char *data() const;

  int kind() const;

  void from(const char *file);

  void from(unsigned char *buffer, int length);

private:
  int width_;
  int height_;
  int kind_;
  unsigned char *data_;
};
}

#endif /* LLImage_hpp */
