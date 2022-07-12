#version 300 es

layout(location = 0) in vec3 aPosition;
layout(location = 1) in vec2 aTexCoord;
layout(location = 2) in vec3 aNormal;
layout(location = 3) in vec3 aTangent;
layout(location = 4) in vec3 aBitangent;

uniform mat4 uProjectionMat;
uniform mat4 uViewMat;
uniform mat4 uModelMat;

out vec4 oPosition;
out vec2 oTexCoord;
out mat3 oTbnMat;

void main() {
  mat4 mvMat = uViewMat * uModelMat;
  gl_Position = uProjectionMat * mvMat * vec4(aPosition, 1.0);
  
  oTexCoord = aTexCoord;
  oPosition = uModelMat * vec4(aPosition, 1.0);
  
  mat3 transposed = mat3(transpose(inverse(uModelMat)));
  vec3 normal = normalize(transposed * aNormal);
  vec3 tangent = normalize(transposed * aTangent);
  vec3 bitangent = normalize(transposed * aBitangent);
  
  oTbnMat = mat3(tangent, bitangent, normal);
}
