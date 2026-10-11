shader_type canvas_item;

uniform int grid_size;
uniform int line_width;

void fragment() {
	vec2 uv_grid_size = float(grid_size) * TEXTURE_PIXEL_SIZE;
	vec2 uv_line_size = float(line_width) * TEXTURE_PIXEL_SIZE;
	
	if (modf(UV.x, uv_grid_size.x) < uv_line_size.x) {
		COLOR = vec4(1., 1., 1., 1.);
	} else {
		COLOR = vec4(0., 0., 0., 0.);
	}
}
