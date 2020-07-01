#version 300 es
precision highp float;

out vec4 FragColor;

in vec3 Normal;
in vec3 FragPos;

struct Material {
    vec3 diffuse;
};
struct Light {
    vec3 position;
    vec3 diffuse;
};

uniform Material material;
uniform Light light;

void main() {
    vec3 norm = normalize(Normal);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = light.diffuse * (diff * material.diffuse);

    FragColor = vec4(diffuse, 1.0);
}
