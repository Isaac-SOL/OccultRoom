shader_type canvas_item;

uniform float strength: hint_range(0.0, 1.0, 0.05) = 0.5;

uniform sampler2D screen_texture: hint_screen_texture;

void fragment() {
	vec3 base_color = texture(screen_texture, SCREEN_UV).rgb;
	vec2 uvR = SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x, 0);
	vec2 uvB = SCREEN_UV - vec2(SCREEN_PIXEL_SIZE.x, 0);
	vec3 aberration_color = vec3(texture(screen_texture, uvR).r,
								 base_color.g,
								 texture(screen_texture, uvB).b);
	COLOR.rgb = mix(base_color, aberration_color, strength);
}
