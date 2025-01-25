shader_type canvas_item;

uniform vec4 modulate:source_color = vec4(1.0);
uniform float gamma_amount:hint_range(0,1000.0) = 100.0;
uniform float bright_amount:hint_range(0,1000.0) = 100.0;
uniform float contrast_amount:hint_range(0,1000.0) = 100.0;
uniform float saturation_amount:hint_range(0,1000.0) = 100.0;
uniform float hue_amount:hint_range(0.0,100.0) = 0.0;

uniform bool enable_palette = false;
uniform sampler2D palette:source_color;

uniform bool enable_outline = false;
uniform vec4 outline_color:source_color;
uniform float outline_width:hint_range(0.0, 10.0,1.0) = 1.0;

// New wave uniforms
uniform bool enable_wave = false;
uniform sampler2D wave_texture;
uniform float wave_speed:hint_range(0.0, 10.0) = 1.0;
uniform float wave_amplitude:hint_range(0.0, 5.0) = 0.5;
uniform float time_scale:hint_range(0.0, 100.0) = 0.5;

vec4 _palette(vec4 color) {
    if (color.a > 0.0) {
        float mindiff = 10.0;
        vec3 colornoa = (color.rgb);
        vec2 palette_size = vec2(textureSize(palette, 0));
        vec2 pixel_size = 1.0 / palette_size;
        float final_pos = 0.0;

        for (int i = 0; i < int(palette_size.x); i++) {
            float pos = float(i) * pixel_size.x + pixel_size.x/2.0;
            vec4 acolorpalette = texture(palette, vec2(pos, 0.0));
            if (acolorpalette.a > 0.0) {
                vec3 colorpalette = (acolorpalette.rgb);
                float diff = distance(colornoa, colorpalette);
                if (diff < mindiff) {
                    mindiff = diff;
                    final_pos = pos;
                }
            }
        }
        color = texture(palette, vec2(final_pos, 0.0));
    }
    return color;
}

vec3 hue_shift(vec3 color, float shift) {
    vec3 h = vec3(0.55735) * dot(vec3(0.55735), color);
    vec3 inv_h = color - h;
    vec3 v = cross(vec3(0.55735), inv_h);
    color = inv_h * cos(shift * 6.2832) + v * sin(shift * 6.2832) + h;
    return color;
}

vec3 gamma(vec3 color, float g) {
    return clamp(pow(color, vec3(g)), vec3(0.0), vec3(1.0));
}

mat4 brightnessMatrix(float brightness) {
    brightness -= 1.0;
    return mat4(
        vec4(1.0, 0.0, 0.0, 0.0),
        vec4(0.0, 1.0, 0.0, 0.0),
        vec4(0.0, 0.0, 1.0, 0.0),
        vec4(brightness, brightness, brightness, 1.0)
    );
}

mat4 contrastMatrix(float contrast) {
    float t = (1.0 - contrast) / 2.0;
    return mat4(
        vec4(contrast, 0.0, 0.0, 0.0),
        vec4(0.0, contrast, 0.0, 0.0),
        vec4(0.0, 0.0, contrast, 0.0),
        vec4(t, t, t, 1.0)
    );
}

mat4 saturationMatrix(float saturation) {
    vec3 luminance = vec3(0.3086, 0.6094, 0.0820);
    float oneMinusSat = 1.0 - saturation;

    vec3 red = vec3(luminance.x * oneMinusSat);
    red += vec3(saturation, 0.0, 0.0);

    vec3 green = vec3(luminance.y * oneMinusSat);
    green += vec3(0.0, saturation, 0.0);

    vec3 blue = vec3(luminance.z * oneMinusSat);
    blue += vec3(0.0, 0.0, saturation);

    return mat4(
        vec4(red, 0.0),
        vec4(green, 0.0),
        vec4(blue, 0.0),
        vec4(0.0, 0.0, 0.0, 1.0)
    );
}

vec4 apply_outline(vec4 color, vec2 uv, sampler2D tex, vec2 ps) {
    vec4 saved_color = color;
    if (color.a == 0.0) {
        for (float o = 1.0; o <= outline_width; o += 1.0) {
            bool ok = false;
            for (int i = 0; i < 16; i++) {
                float angle = PI/8.0 * float(i);
                float outline = o;
                if (i % 4 != 0 && o == 1.0) {
                    outline = max(0.0, o - 1.0);
                }
                vec4 neighbor = texture(tex, uv + vec2(cos(angle), sin(angle)) * -outline * ps);

                if (neighbor.a > 0.0) {
                    ok = true;
                    break;
                }
            }
            if (ok) {
                color = outline_color;
                return color;
            }
        }
    }
    return saved_color;
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    if (enable_wave) {
	float wave = texture(wave_texture, vec2(
	    UV.x + sin(TIME * 0.5) * 0.1,
	    UV.y + cos(TIME * 0.3) * 0.1
	)).r;
    if (color.a > 0.0) {
        color.rgb /= color.a;
    }

    if (enable_palette) {
        color = _palette(color);
    }

    color = color * modulate;
    color = brightnessMatrix(bright_amount/100.0) *
            contrastMatrix(contrast_amount/100.0) *
            saturationMatrix(saturation_amount/100.0) * color;
    color.rgb = gamma(color.rgb, gamma_amount/100.0);
    color.rgb = hue_shift(color.rgb, hue_amount/100.0);
    color = clamp(color, vec4(0.0), vec4(1.0));

    if (enable_outline) {
        vec2 ps = TEXTURE_PIXEL_SIZE;
        color = apply_outline(color, UV, TEXTURE, ps);
    }
    color.a *= 1.0 - (wave * wave_amplitude);
    COLOR = color;
}
}