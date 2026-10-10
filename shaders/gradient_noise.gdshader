shader_type canvas_item;
uniform sampler2D noise;
uniform float debanding_intensity: hint_range(0.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = texture(TEXTURE, UV + (texture(noise, UV).r - 0.5) * debanding_intensity);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
