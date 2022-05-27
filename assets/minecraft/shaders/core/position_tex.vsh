#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

out vec2 texCoord0;

void main() {
	// by shmoobalizer
	ivec2 texSize = textureSize(Sampler0, 0);
	vec3 Pos = Position;
	vec2 uv = UV0;
	if (texSize == ivec2(128,16)) {
		Pos.yz = vec2((Pos.y-67)*90,Pos.z-1);
		if (uv.x > uv.x/2) {
			Pos.x *= 2;
		} else {
			Pos.x = 0;
		}
		uv = vec2(Pos.x/256,UV0.y*45);
	}
	gl_Position = ProjMat * ModelViewMat * vec4(Pos, 1.0);
	texCoord0 = uv;
}
