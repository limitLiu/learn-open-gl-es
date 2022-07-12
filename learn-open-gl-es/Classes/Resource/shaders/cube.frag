#version 300 es
precision highp float;

uniform sampler2D uTexture;

in vec2 outUV;
out vec4 outColor;

void main() {
  outColor = texture(uTexture, outUV);
}
