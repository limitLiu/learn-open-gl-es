//
//  YUV.h
//  Renderer
//
//  Created by limit on 2022/7/3.
//

#ifndef LLYUV_h
#define LLYUV_h

typedef struct LLYUVData {
  size_t length;
  uint8_t *data;
} LLYUVData;

typedef struct LLYUVFrame {
  int32_t width;
  int32_t height;
  LLYUVData luma;
  LLYUVData chromaB;
  LLYUVData chromaR;
} LLYUVFrame;

typedef struct LLVertex {
  float x, y, z;
  float u, v;
} LLVertex;

#endif /* LLYUV_h */
