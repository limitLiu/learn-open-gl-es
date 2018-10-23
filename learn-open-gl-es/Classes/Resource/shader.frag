#version 300 es
precision mediump float;
out vec4 fragColor;
in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D ourTexture;

void main() {
    fragColor = texture(ourTexture, texCoord);
}
