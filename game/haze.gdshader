shader_type canvas_item;
render_mode blend_add;
uniform vec4 haze_color: source_color;
uniform sampler2D noise;
uniform sampler2D noise_2;
uniform float noise_intensity;
uniform float noise_2_intensity;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 p = vec2(UV.x, UV.y + sin(TIME*1.+UV.x*1.)*0.1 + 0.1);
	float haze = texture(noise, vec2(p.x,p.y)).r * noise_intensity;
	COLOR = vec4(haze_color.rgb,(1.0-clamp(sin(TIME+UV.x),0.0,1.0)*0.1-haze));
	COLOR.a *= clamp(cos(haze+haze*TIME/30.)*0.4-abs(UV.y-0.5)*0.9,0.0,1.0);
	COLOR.a *= 0.2;
	
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
