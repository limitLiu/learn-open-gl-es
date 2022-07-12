#version 300 es
precision highp float;

struct Light {
  vec3 position;
  vec3 ambient;
  vec3 diffuse;
  vec3 specular;
  float c;
  float l;
  float q;
};

uniform Light light;
uniform sampler2D textureDiffuse;
uniform sampler2D textureNormal;
uniform sampler2D textureSpecular;

uniform float uShine;
uniform vec3 uViewPosition;

in vec4 oPosition;
in vec2 oTexCoord;
in mat3 oTbnMat;

out vec4 outColor;

void main() {
  vec3 normal = texture(textureNormal, oTexCoord).rgb;
  normal = normalize(normal * 2.0f - 1.0f);
  normal = normalize(oTbnMat * normal);

  float dist = length(light.position - oPosition.xyz);
  float attenuation = 1.0f / (light.c + light.l * dist + light.q * dist * dist);
  vec3 ambient = light.ambient * vec3(texture(textureDiffuse, oTexCoord).rgb);
  vec3 lightDirection = normalize(light.position - oPosition.xyz);
  float diff = max(dot(normal, lightDirection), 0.0f);
  vec3 diffuse = light.diffuse * diff * vec3(texture(textureDiffuse, oTexCoord).rgb);

  float specularStrength = 0.5f;
  vec3 viewDirection = normalize(uViewPosition - oPosition.xyz);
  vec3 reflectDirection = reflect(-lightDirection, normal);
  float spec = pow(max(dot(viewDirection, reflectDirection), 0.0f), uShine);
  vec3 specular = specularStrength * light.specular * spec;
  vec3 result = ambient + diffuse + specular;
  outColor = vec4(result, 1.0f);
}
