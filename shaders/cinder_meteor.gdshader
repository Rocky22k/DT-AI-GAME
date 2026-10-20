shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform vec4 crust_color : source_color = vec4(0.08, 0.05, 0.03, 1.0);
uniform vec4 lava_color : source_color = vec4(1.0, 0.35, 0.05, 1.0);
uniform float crack_scale = 12.0;

void fragment() {
	vec3 p = VERTEX * crack_scale;
	float cracks = sin(p.x * 2.0) * sin(p.y * 2.0) * sin(p.z * 2.0);
	float lava = smoothstep(0.4, 0.7, cracks);

	vec3 col = mix(crust_color.rgb, lava_color.rgb * 4.0, lava);
	ALBEDO = crust_color.rgb;
	EMISSION = lava_color.rgb * lava * 3.5;
	ROUGHNESS = 0.8;
}
