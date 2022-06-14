#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;
uniform float GameTime;

in float vertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * ColorModulator;
	
	vec4 tex0 = texture(Sampler0, texCoord0);
	
	if (abs(tex0.a - 248.0 / 255.0) < 0.001 || abs(tex0.a - 249.0 / 255.0) < 0.001) {
		if (tex0.rgb == vec3(0)) {
			discard;
		}
	}
	
    if (tex0.a != 252/255.0) {
        color *= vertexColor;
    }
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
