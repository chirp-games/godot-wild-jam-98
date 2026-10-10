shader_type canvas_item;
uniform float water_line: hint_range(0.0, 1.0, 0.0);
uniform vec4 foam_color: source_color;
uniform float foam_size: hint_range(0.0, 1.0, 0.0);
uniform vec4 subfoam_color: source_color;
uniform float subfoam_size: hint_range(0.0, 1.0, 0.0);
uniform vec4 top_water_color: source_color;
uniform float top_water_size: hint_range(0.0, 1.0, 0.0);
uniform vec4 mid_water_color: source_color;
uniform float mid_water_size: hint_range(0.0, 1.0, 0.0);
uniform vec4 low_water_color: source_color;

uniform float foam_mix_intensity: hint_range(0.0, 1.0, 0.001);
uniform float mix_3_intensity: hint_range(0.0, 1.0, 0.001);
uniform float mix_4_intensity: hint_range(0.0, 1.0, 0.001);

uniform float wave_amplitude: hint_range(0.0, 5.0, 0.0);
uniform float wave_frequency: hint_range(0.0, 5.0, 0.0);

//https://iquilezles.org/articles/smin/
vec2 smin( float a, float b, float k )
{
    float h = 1.0 - min( abs(a-b)/(4.0*k), 1.0 );
    float w = h*h;
    float m = w*0.5;
    float s = w*k;
    return (a<b) ? vec2(a-s,m) : vec2(b-s,1.0-m);
}

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
	COLOR = vec4(0.0);
	
	vec2 p = vec2(UV.x,UV.y + sin(TIME * wave_frequency) * wave_amplitude * sin(TIME + UV.x * wave_frequency));
		
	float sky = sdBox(p,vec2(2.0,water_line));
	float foam = sdBox(p-vec2(0.0,water_line+foam_size),vec2(2.0,foam_size));
	float subfoam = sdBox(p-vec2(0.0,water_line+foam_size+subfoam_size),vec2(2.0,subfoam_size));
	float top_water = sdBox(p-vec2(0.0,water_line+foam_size+subfoam_size+top_water_size),vec2(2.0,top_water_size));
	float mid_water = sdBox(p-vec2(0.0,water_line+foam_size+top_water_size+subfoam_size+mid_water_size),vec2(2.0,mid_water_size));
	float low_water = sdBox(p-vec2(0.0,1.0),vec2(2.0,1.0-(water_line+foam_size+subfoam_size+top_water_size+mid_water_size)));
	
	vec2 mixed_foam_sky = smin(sky,foam,foam_mix_intensity);
	vec2 mixed_subfoam_foam = smin(foam,subfoam,foam_mix_intensity);
	vec2 mixed_foam_water = smin(subfoam,top_water,foam_mix_intensity);
	vec2 mixed_top_mid = smin(top_water,mid_water,mix_3_intensity);
	vec2 mixed_mid_low = smin(mid_water,low_water,mix_4_intensity);
	
	vec4 mix_1 = mix(foam_color,subfoam_color,mixed_subfoam_foam.y);
	vec4 mix_2 = mix(mix_1,top_water_color,mixed_foam_water.y);
	vec4 mix_3 = mix(mix_2,mid_water_color,mixed_top_mid.y);
	vec4 mix_4 = mix(mix_3,low_water_color,mixed_mid_low.y);
	vec4 mix_5 = mix(vec4(foam_color.rgb,0.0),mix_4,mixed_foam_sky.y);

	COLOR = mix_5;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
