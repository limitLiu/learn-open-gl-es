#version 300 es
layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec2 aTexCoord;

uniform mat4 uMat;
out vec2 outTexCoord;

void main() {
  outTexCoord = aTexCoord;
  gl_Position = uMat * vec4(aPosition, 1.0);
}
