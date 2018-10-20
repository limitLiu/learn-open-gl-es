#version 300 es
precision mediump float;
out vec4 fragColor;
//in vec3 ourColor;
in vec3 ourPosition;

void main() {
    fragColor = vec4(ourPosition, 1.0);
}
