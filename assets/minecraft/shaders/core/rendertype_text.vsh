#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = fog_distance(ModelViewMat, IViewRotMat * Position, FogShape);

    //vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
	// written by shmoobalizer
	vec4 color = Color;
	
	if (floor(Position.z) == 400) {
		if ( Color.rgb == vec3(255,255, 85)/255 ) { color = vec4(1); } // uncommon (yellow)
		if ( Color.rgb == vec3( 63, 63, 21)/255 ) { color.rgb = vec3(63)/255; }
		if ( Color.rgb == vec3( 85,255,255)/255 ) { color = vec4(1); } // rare|enchanted (cyan)
		if ( Color.rgb == vec3( 21, 63, 63)/255 ) { color.rgb = vec3(63)/255; }
		if ( Color.rgb == vec3(255, 85,255)/255 ) { color = vec4(1); } // epic (magenta)
		if ( Color.rgb == vec3( 63, 21, 63)/255 ) { color.rgb = vec3(63)/255; }
	} else if (Color.r > 0.495 && Color.r < 0.515 && // check color range
		Color.g > 0.95 && 
		Color.b > 0.124 && Color.b < 0.126 &&
		Position.z == 0) { // check position/layer
		color = vec4(0.494,0.537,0.486,1);
	}
	vertexColor = color * texelFetch(Sampler2, UV2 / 16, 0);
	
	/*if (-(ModelViewMat * vec4(1)).z < 1000 && (ProjMat * vec4(1)).y < 1.5 ) {
		vertexColor = vec4(1,0,0,1);
	} else {
		vertexColor = vec4(0,1,1,1);
	}*/
	
    texCoord0 = UV0;
}
