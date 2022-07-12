#version 300 es
precision highp float;

uniform sampler2D uTexture;
in vec2 outUV;
out vec4 outColor;

void main() {
  vec4 color = texture(uTexture, outUV);
  if (color.a < 0.1) {
    discard;
  }
  outColor = color;
}
