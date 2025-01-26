shader_type canvas_item;
uniform vec4 bg_color: source_color;
uniform float star_size = 400.0;
uniform float star_thickness = 2.0;

float rand(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
    float prob = 0.8	;
    vec2 pos = floor(1.0 / star_size * FRAGCOORD.xy);
    float color = 0.0;
    float starValue = rand(pos);
    
    if (starValue > prob)
    {
        vec2 center = star_size * pos + vec2(star_size, star_size) * 0.5;
        float t = 0.9 + 0.2 * sin(TIME * 8.0 + (starValue - prob) / (1.0 - prob) * 45.0);
        vec2 delta = abs(FRAGCOORD.xy - center);
        if (delta.x < star_thickness && delta.y < star_thickness) {
            color = t;
        }
    }

    COLOR = vec4(vec3(color),1.0) + bg_color;
}
