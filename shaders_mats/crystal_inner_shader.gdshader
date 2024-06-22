shader_type spatial;

uniform sampler2D crystal_texture;
uniform sampler2D mask_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(crystal_texture, UV).rgb;
	EMISSION = texture(crystal_texture, UV).rgb * 0.1;
	ALPHA = texture(mask_texture, UV).a;
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
