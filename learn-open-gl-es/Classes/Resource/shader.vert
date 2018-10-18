#version 300 es
in vec3 aPosition;
out vec4 vertexColor;
void main() {
    gl_Position = vec4(aPosition, 1.0);
    vertexColor = vec4(0.5, 0.0, 0.0, 1.0);
}
