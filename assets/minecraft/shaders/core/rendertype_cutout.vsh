#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;
uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform vec3 ChunkOffset;
uniform int FogShape;
uniform float GameTime;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out vec4 normal;

mat3 rotateX(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(1, 0, 0),
        vec3(0, c, -s),
        vec3(0, s, c)
    );
}
mat3 rotateY(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, 0, s),
        vec3(0, 1, 0),
        vec3(-s, 0, c)
    );
}
mat3 rotateZ(float theta) {
    float c = cos(theta);
    float s = sin(theta);
    return mat3(
        vec3(c, -s, 0),
        vec3(s, c, 0),
        vec3(0, 0, 1)
    );
}

bool check_alpha (float alpha, float target) {
	if (abs(alpha - target / 255.0) < 0.001) {return true;}
	else {return false;}
}

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
	
	float alpha0 = texture(Sampler0, UV0).a;
	if (check_alpha(alpha0,248.0)||check_alpha(alpha0,249.0)||check_alpha(alpha0,250.0)) {
		pos -= ChunkOffset;
		vec3 center = floor(pos) + 0.5;
		pos = rotateY(GameTime*1200) * (pos - center) + center;
		if (check_alpha(alpha0,248.0)||check_alpha(alpha0,250.0)) {
			pos = rotateX(GameTime*1200) * (pos - center) + center;
		}
		if (check_alpha(alpha0,250.0)) {
			pos = rotateZ(GameTime*1200) * (pos - center) + center;
		}
		pos.y += 0.1 * sin(GameTime*2400) + 0.05;
		
		gl_Position = ProjMat * ModelViewMat * vec4(pos + ChunkOffset, 1.0);
		
		color = vec4(vec3(0.9),1);
	}
	
    vertexColor = color * minecraft_sample_lightmap(Sampler2, UV2);
	
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
