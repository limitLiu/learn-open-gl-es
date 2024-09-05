#version 300 es

precision highp float;

out vec4 fragColor;
in vec3 ourColor;
in vec2 texCoord;

uniform sampler2D texture1;
uniform sampler2D texture2;
uniform float mixVal;

void main() {
    fragColor = mix(texture(texture1, texCoord),
    texture(texture2, vec2(texCoord.x, texCoord.y)), mixVal) * vec4(ourColor, 1.0f);
}
