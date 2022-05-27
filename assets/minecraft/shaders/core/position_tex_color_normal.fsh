#version 150

#moj_import <fog.glsl>

#define MC_CLOUD_VERSION 11802

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;


uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform int FogShape;

in vec2 texCoord0;
in vec3 vertexPosition;
in vec4 vertexColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.5) {
        discard;
    }
    #if MC_CLOUD_VERSION == 11802
      fragColor = linear_fog(color, fog_distance(mat4(1.0), vertexPosition, FogShape), FogStart, FogEnd, FogColor);
    #elif MC_CLOUD_VERSION == 11801
      fragColor = linear_fog(color, cylindrical_distance(mat4(1.0), vertexPosition), FogStart, FogEnd, FogColor);
    #else
      fragColor = linear_fog(color, length(vertexPosition), FogStart, FogEnd, FogColor);
    #endif
}
