#version 150

/*
code by fayer3
*/

#define MC_CLOUD_VERSION 11802

#if MC_CLOUD_VERSION == 11700
  const float VANILLA_CLOUD_HEIGHT = 128.0;
#else
  const float VANILLA_CLOUD_HEIGHT = 192.0;
#endif

const float CLOUD_HEIGHT = 110.00000000;

#moj_import <fog.glsl>

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in vec3 Normal;

uniform mat4 ModelViewMat;
uniform mat4 IViewRotMat;

mat3 actualIViewRotMat = mat3(IViewRotMat[0][0], IViewRotMat[0][1], IViewRotMat[0][2], IViewRotMat[0][3], IViewRotMat[1][0], IViewRotMat[1][1], IViewRotMat[1][2], IViewRotMat[1][3], IViewRotMat[2][0]);

uniform mat4 ProjMat;
uniform sampler2D Sampler0;

out vec2 texCoord0;
out vec3 vertexPosition;
out vec4 vertexColor;

void main() {
    texCoord0 = UV0;
    vertexColor = Color;
    vec3 newPosition = vec3(Position.x, Position.y+(CLOUD_HEIGHT-VANILLA_CLOUD_HEIGHT), Position.z);
    if (abs(Normal.y) > 0.9) {
      if (Position.x < 7.9  || (Position.x < 8.1 && (gl_VertexID % 4 == 1 || gl_VertexID % 4 == 2))) {
        // usual top/bottom
        texCoord0 = vec2(UV0.x + (((newPosition.x+24.0))/float(textureSize(Sampler0, 0).x)),UV0.y);
        newPosition = vec3((newPosition.x+8.0)*2.0+8.0, newPosition.y, newPosition.z);
        vertexPosition = actualIViewRotMat*(ModelViewMat * vec4(newPosition, 1.0)).xyz;
        gl_Position = ProjMat * ModelViewMat * vec4(newPosition, 1.0);
      }
      else if (abs(Position.y) > 7.5){ // try not to offset if both sides are drawn
        // opposite top/bottom
        texCoord0 = vec2(UV0.x + (((newPosition.x-40.0))/float(textureSize(Sampler0, 0).x)),UV0.y);
        newPosition = vec3((newPosition.x-24.0)*2.0+8.0, newPosition.y-sign(Normal.y)*4.0, newPosition.z);
        vertexColor.rgb *= Normal.y < 0.0 ? vec3(1.4326) : vec3(0.698);
        vertexPosition = actualIViewRotMat*(ModelViewMat * vec4(newPosition, 1.0)).xyz;
        gl_Position = ProjMat * ModelViewMat * vec4(newPosition, 1.0);
      }
      else {
        // these shouldn't be rendered move them outside the frustum
        gl_Position = vec4(-10.0);
      }
    } else {
      vertexPosition = actualIViewRotMat*(ModelViewMat * vec4(newPosition, 1.0)).xyz;
      gl_Position = ProjMat * ModelViewMat * vec4(newPosition, 1.0);
    }
}
