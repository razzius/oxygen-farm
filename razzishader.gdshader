shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(1, 1, 1, 1);
uniform vec4 color2 : source_color = vec4(1, 1, 1, 1);

void vertex() {
	// Called for every vertex the material is visible on.
	COLOR = vec4(mix(color1, color2, UV.y + 0.2));
}

void fragment() {
	//COLOR = vec4(0.4, 0.6, 0.9, 1.0);
	// COLOR = vec4(mix(color1, color2, SCREEN_UV.y + 0.2));
// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
