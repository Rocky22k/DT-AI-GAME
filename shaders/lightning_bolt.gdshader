shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 bolt_core_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 bolt_glow_color : source_color = vec4(0.3, 0.7, 1.0, 0.85);
uniform float jitter_amount = 0.8;
uniform float jitter_speed = 35.0;

void fragment() {
	vec2 p = UV - vec2(0.5, 0.0);

	// Fast piecewise linear style lightning noise
	float flicker = sin(p.y * 30.0 + floor(TIME * jitter_speed)) * jitter_amount * 0.1;
	float dist_to_axis = abs(p.x - flicker);

	float core = 1.0 - smoothstep(0.0, 0.04, dist_to_axis);
	float halo = 1.0 - smoothstep(0.04, 0.35, dist_to_axis);

	vec3 col = bolt_core_color.rgb * core * 2.0 + bolt_glow_color.rgb * halo;
	float alpha = clamp(core + halo * bolt_glow_color.a, 0.0, 1.0);

	ALBEDO = col;
	ALPHA = alpha;
}
