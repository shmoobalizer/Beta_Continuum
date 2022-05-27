#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;

bool fleeceColHex (vec3 inVal, int target, float del) {
	// written by shmoobalizer
	if (distance(toHsv(inVal), 
	             toHsv(frmHex(target))) < del) {
		return true;
	} else {
		return false;
	}
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);
    
	//vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    // written by shmoobalizer
	vec3 v3colorMod = Color.rgb;
	if (Color.a == 1) {
		if (fleeceColHex(Color.rgb,0xF9801D,0.25)) { // orange
			v3colorMod = frmHex(0xF2B333);
		} else if (fleeceColHex(Color.rgb,0xF38BAA,0.25)) { // pink
			v3colorMod = frmHex(0xF2B3CC);
		} else if (fleeceColHex(Color.rgb,0xC74EBD,0.25)) { // magenta
			v3colorMod = frmHex(0xE680D9);
		} else if (fleeceColHex(Color.rgb,0x3AB3DA,0.25)) { // light blue
			v3colorMod = frmHex(0x99B3F2);
		} else if (fleeceColHex(Color.rgb,0xFED83D,0.3)) { // yellow
			v3colorMod = frmHex(0xE6E633);
		} else if (fleeceColHex(Color.rgb,0x80C71F,0.25)) { // lime
			v3colorMod = frmHex(0x80CC1A);
		} else if (fleeceColHex(Color.rgb,0x474F52,0.25)) { // gray
			v3colorMod = frmHex(0x4D4D4D);
		} else if (fleeceColHex(Color.rgb,0x9D9D97,0.25)) { // light gray
			v3colorMod = frmHex(0x999999);
		} else if (fleeceColHex(Color.rgb,0x169C9C,0.25)) { // cyan
			v3colorMod = frmHex(0x4D99B3);
		} else if (fleeceColHex(Color.rgb,0x8932B8,0.25)) { // purple
			v3colorMod = frmHex(0xB366E6);
		} else if (fleeceColHex(Color.rgb,0x3C44AA,0.25)) { // blue
			v3colorMod = frmHex(0x3366CC);
		} else if (fleeceColHex(Color.rgb,0x835432,0.15)) { // brown
			v3colorMod = frmHex(0x80664D);
		} else if (fleeceColHex(Color.rgb,0x5E7C16,0.2)) { // green
			v3colorMod = frmHex(0x668033);
		} else if (fleeceColHex(Color.rgb,0xB02E26,0.25)) { // red
			v3colorMod = frmHex(0xCC4D4D);
		} else if (fleeceColHex(Color.rgb,0x1D1D21,0.25)) { // black
			v3colorMod = frmHex(0x1A1A1A);
		} else {}
	}
	vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, vec4(v3colorMod,1));
	
	//lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
	lightMapColor = minecraft_sample_lightmap(Sampler2, UV2);  // sample lightmap directly for custom color.
    overlayColor = texelFetch(Sampler1, UV1, 0);
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
