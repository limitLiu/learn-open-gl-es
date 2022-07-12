//
//  LLImage.cpp
//  Renderer
//
//  Created by limit on 2022/7/7.
//

#include "LLImage.hpp"
#include <iostream>

#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

Renderer::Image::Image(): width_(0), height_(0), kind_(0), data_(nullptr) {
}

Renderer::Image::~Image() {
  if (data_ != nullptr) {
    free(data_);
    data_ = nullptr;
  }
}

void Renderer::Image::from(const char *file) {
  stbi_set_flip_vertically_on_load(true);
  stbi_convert_iphone_png_to_rgb(1);
  
  int width = 0, height = 0, kind = 0;
  unsigned char *data = stbi_load(file, &width, &height, &kind, STBI_rgb_alpha);
  size_t size = static_cast<size_t>(width * height * 4);
  if (size > 0 && data != nullptr) {
    data_ = (unsigned char *) malloc(size);
    memcpy(data_, data, size);
    width_ = width;
    height_ = height;
    kind_ = kind;
  }
  stbi_image_free(data);
}

void Renderer::Image::from(unsigned char *buffer, int length) {
  int width = 0, height = 0, kind = 0;
  stbi_set_flip_vertically_on_load(true);
  stbi_convert_iphone_png_to_rgb(1);
  uint8_t *data = stbi_load_from_memory(buffer, length, &width, &height, &kind, 0);
  size_t size = static_cast<size_t>(width * height * 4);
  if (size > 0 && data != nullptr) {
    data_ = (uint8_t *) malloc(size);
    memcpy(data_, data, size);
    width_ = width;
    height_ = height;
    kind_ = kind;
  }
  stbi_image_free(data);
}

int Renderer::Image::width() const {
  return width_;
}

int Renderer::Image::height() const {
  return height_;
}

unsigned char *Renderer::Image::data() const {
  return data_;
}

int Renderer::Image::kind() const {
  return kind_;
}
