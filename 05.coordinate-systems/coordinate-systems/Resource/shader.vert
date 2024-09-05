#version 300 es

layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aTexCoord;

out vec3 ourColor;
out vec2 texCoord;

uniform mat4 mat;

void main() {
    gl_Position = mat * vec4(aPosition, 1.0);
    ourColor = aColor;
    texCoord = aTexCoord;
}
