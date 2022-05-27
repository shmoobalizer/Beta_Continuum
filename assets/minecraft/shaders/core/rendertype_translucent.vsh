#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ChunkOffset;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

void main() {
    vec3 pos = Position + ChunkOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
	
	// by shmoobalizer
	vec4 color = Color;
	if (color.r == 229.0/255.0) { // nether
		if (Normal.y == 1.0) { // top
			color = vec4(1,1,1,color.a);
		}
		if (Normal.y == -1.0) { // bottom
			color = vec4(0.5,0.5,0.5,color.a);
		}
	}
    vertexColor = color * minecraft_sample_lightmap(Sampler2, UV2);
	
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
