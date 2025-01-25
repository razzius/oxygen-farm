shader_type spatial;
uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform sampler2D wave;
uniform vec2 wave_direction = vec2(2.0,0.0);
uniform vec2 wave_direction2 = vec2(0.0,1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;
uniform float noise_scale = 10.0;
uniform float height_scale = 0.05;
uniform float edge_scale = 0.1;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;
uniform float seed = 0.0; // Add seed uniform

varying float height;
varying vec3 world_pos;

float fresnel(float amount, vec3 normal, vec3 view) {
    return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0 )), amount);
}

void vertex() {
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    height = texture(wave, world_pos.xz / noise_scale + TIME * time_scale).r;
}

void fragment() {
    vec2 time = (TIME * wave_direction) * time_scale;
    vec2 time2 = (TIME * wave_direction2) * time_scale;

    // Add seed offset to texture coordinates
    vec2 offset = vec2(cos(seed), sin(seed));
    vec3 normal_mix = mix(texture(texture_normal, world_pos.xz + time + offset).rgb,
                         texture(texture_normal, world_pos.xz + time2 + offset).rgb, 0.5);

    float transparency = texture(texture_normal2, world_pos.xz + time2 + offset).r;

    float fresnel = fresnel(5.0, NORMAL, VIEW);
    vec3 surface_color = mix(albedo, albedo2, fresnel);

    ALBEDO = surface_color;
    METALLIC = metallic;
    ROUGHNESS = roughness;
    NORMAL_MAP = normal_mix;
    ALPHA = transparency;
}