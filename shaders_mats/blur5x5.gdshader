shader_type spatial;
render_mode unshaded;

uniform bool vertical;
uniform sampler2D screen: hint_screen_texture;

const vec2 pixel_size = vec2(1.0 / 640.0, 1.0 / 360.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 pixel_offset = vertical ? vec2(pixel_size.x, 0) : vec2(0, pixel_size.y);
	vec2 uv1 = SCREEN_UV;
	vec2 uv0 = SCREEN_UV + pixel_offset * 1.2;
	vec2 uv2 = SCREEN_UV - pixel_offset * 1.2;
	vec3 col0 = texture(screen, uv0).rgb;
	vec3 col1 = texture(screen, uv1).rgb;
	vec3 col2 = texture(screen, uv2).rgb;
	ALBEDO = (col0 * 5.0 + col1 * 6.0 + col2 * 5.0) / 16.0;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
