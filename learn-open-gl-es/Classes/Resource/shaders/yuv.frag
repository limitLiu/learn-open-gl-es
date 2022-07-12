#version 300 es
precision highp float;

uniform sampler2D uTextureY;
uniform sampler2D uTextureU;
uniform sampler2D uTextureV;

in vec2 outTexCoord;
out vec4 outColor;

void main(void) {
  vec3 yuv;
  yuv.x = texture(uTextureY, outTexCoord).r;
  yuv.y = texture(uTextureU, outTexCoord).r - 0.5;
  yuv.z = texture(uTextureV, outTexCoord).r - 0.5;
  vec3 rgb = mat3(1.0, 1.0, 1.0, 0, -0.39465, 2.03211, 1.13983, -0.58060, 0.0) * yuv;
  outColor = vec4(rgb, 1.0);
}

