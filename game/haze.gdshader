shader_type canvas_item;

uniform vec4 haze_color: source_color;
uniform sampler2D noise;
uniform float noise_intensity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 p = UV;
	float haze = distance(p.y,0.5) * 2. + texture(noise, vec2(p.x,p.y)).r * noise_intensity;
	COLOR = vec4(haze_color.rgb,(1.0-haze)*haze_color.a);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
