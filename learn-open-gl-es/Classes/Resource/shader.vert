#version 300 es
layout (location = 0) in vec3 aPosition;
layout (location = 1) in vec3 aColor;

out vec3 ourColor;

uniform float yOffset;

void main() {
    gl_Position = vec4(aPosition.x, aPosition.y + yOffset, aPosition.z, 1.0);
    ourColor = aColor;
}
