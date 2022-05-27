#version 150

#moj_import <fog.glsl>

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;

out vec4 fragColor;

void main() {
	vec4 skyColor = ColorModulator;
	if (!fzyEqlV3(ColorModulator.rgb,frmHex(0x2222FF),0.2) && (
			fzyEqlV3(ColorModulator.rgb,frmHex(0x010101),0.2) || 
			!(fzyEqlV3(ColorModulator.rgb,frmHex(0x4A4A4A),0.3) && 
			ColorModulator.r == ColorModulator.b)
		) 
	) { // if sky
		vec3 skyColorHSV = toHsv(ColorModulator.rgb);
		vec3 daySkyColorHSV = skyColorHSV;
		daySkyColorHSV = skyColorHSV + vec3(
			skyColorHSV.x - toHsv(vec3(0.5,0.6555,1)).x,
			skyColorHSV.y - 0.53,
			0
		) * vec3(2,2,1);
		daySkyColorHSV.x = max(daySkyColorHSV.x,0.5889);
		daySkyColorHSV.y = min(daySkyColorHSV.y,0.51);
		float daySkyPer = 0.0;
		daySkyPer = skyColorHSV.z;
		skyColor.rgb = mix(vec3(0.0039),hsv2rgb(daySkyColorHSV),daySkyPer);
	} else { // if stars/hl
	}
    fragColor = linear_fog(skyColor, vertexDistance, FogStart, FogEnd, FogColor);
}
