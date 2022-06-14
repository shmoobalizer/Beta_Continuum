#version 150

#define MINECRAFT_LIGHT_POWER   (0.6)
#define MINECRAFT_AMBIENT_LIGHT (0.4)

vec4 minecraft_mix_light(vec3 lightDir0, vec3 lightDir1, vec3 normal, vec4 color) {
    lightDir0 = normalize(lightDir0);
    lightDir1 = normalize(lightDir1);
    float light0 = max(0.0, dot(lightDir0, normal));
    float light1 = max(0.0, dot(lightDir1, normal));
    float lightAccum = min(1.0, (light0 + light1) * MINECRAFT_LIGHT_POWER + MINECRAFT_AMBIENT_LIGHT);
    
	return vec4(color.rgb * lightAccum, color.a);
}

vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
	
	// by shmoobalizer

    vec4 lightVal = texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));

    const float[] BLOCKLIGHT = float[](
	0.0078, 0.0196, 0.0431, 0.0666,
	0.0902, 0.1216, 0.1529, 0.1882,
	0.2275, 0.2784, 0.3373, 0.4118,
	0.5098, 0.6275, 0.7843, 1.0
    );

    const float[] DAYLIGHT = float[](
	0.0431, 0.0549, 0.0784, 0.1020,
	0.1255, 0.1529, 0.1843, 0.2196,
	0.2588, 0.3059, 0.3647, 0.4353,
	0.5216, 0.6353, 0.7882, 1.0
    );

    const float nightshade = 0.1255;

    vec3 mapZero = texelFetch(lightMap, ivec2(0), 0).rgb;
    /*if (texelFetch(lightMap, ivec2(6, 0), 0).r > texelFetch(lightMap, ivec2(6, 0), 0).b || 
      ( mapZero.rg == texelFetch(lightMap, ivec2(0, 15), 0).rg && mapZero.g > mapZero.r )) {*/
        // if vanilla

        float blocklight = BLOCKLIGHT[uv.x >> 4];
        float daylightPer = (texelFetch(lightMap, ivec2(0, 15), 0).b - 0.2784) / 0.7098;
        float lightValBase = 1 - (1 - max(blocklight + mapZero.r - 0.0549,0.0)) * (1 - mix(nightshade,DAYLIGHT[uv.y >> 4],daylightPer));
        lightVal = vec4(lightValBase,lightValBase,lightValBase,1);

        if (mapZero.g > mapZero.r) { // end
            lightVal = vec4(
                1 - (1 - blocklight) * (1 - (0.2275 + mapZero.r - 0.2392)),
                1 - (1 - blocklight) * (1 - (0.2824 + mapZero.g - 0.2980)),
                1 - (1 - blocklight) * (1 - (0.2549 + mapZero.b - 0.2705)),
                1
            );
        } if (mapZero.r > mapZero.g) { // nether

            //float netherMin = 0.0706;
            float netherMin = 0.12;

            lightVal = vec4(
                1 - (1 - blocklight) * (1 - (netherMin + mapZero.r - 0.2824)),
                1 - (1 - blocklight) * (1 - (netherMin + mapZero.g - 0.2392)),
                1 - (1 - blocklight) * (1 - (netherMin + mapZero.b - 0.2039)),
                1
            );
        }
    //}
    
    return lightVal;
}
