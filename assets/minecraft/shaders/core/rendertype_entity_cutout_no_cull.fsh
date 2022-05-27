#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }
	
    color *= ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
	
	// by shmoobalizer
	// enderman
	if (!(texelFetch(Sampler2, ivec2(0), 0).g > texelFetch(Sampler2, ivec2(0), 0).r)) {
        if (fzyEqlV3(texture(Sampler0, texCoord0).rgb,vec3(224,121,250) / 255.0,0.01)) {
				color.rgb = vec3(166,250,121) / 255.0;
		} if (fzyEqlV3(texture(Sampler0, texCoord0).rgb,vec3(204,0,250) / 255.0,0.01)) {
				color.rgb = vec3(83,250,0) / 255.0;
		}
	}
	// emissive by alpha
	if (distance(texture(Sampler0, texCoord0).a,251/255.0)>=0.001) {
		color *= vertexColor;
		if (distance(texture(Sampler0, texCoord0).a,252/255.0)>=0.001) {
			color *= lightMapColor;
		}
	}
	
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
