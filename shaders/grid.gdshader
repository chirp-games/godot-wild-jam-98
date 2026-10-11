shader_type canvas_item;
uniform int grid_size = 1;

//https://iquilezles.org/articles/distfunctions2d/
float sdBox( in vec2 p, in vec2 b )
{
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 p = UV;
	float d = sdBox(p - grid_size*round(p.x*grid_size),vec2(grid_size));
	if (abs(d)<0.01) {
		COLOR.rgb=vec3(1.0);
	} else {
		COLOR.a = 0.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
