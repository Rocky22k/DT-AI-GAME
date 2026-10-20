shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 core_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform vec4 sheath_color : source_color = vec4(0.1, 0.9, 1.0, 0.9);
uniform vec4 coil_color : source_color = vec4(1.0, 0.8, 0.2, 0.9);
uniform float flow_speed = 8.0;

void fragment() {
	vec2 p = UV - vec2(0.5, 0.0);

	float d = abs(p.x);
	float core = 1.0 - smoothstep(0.0, 0.12, d);
	float sheath = 1.0 - smoothstep(0.12, 0.45, d);

	// Spiraling gold coils
	float coil_phase = fract(p.y * 3.0 + p.x * 4.0 - TIME * flow_speed);
	float coil = smoothstep(0.0, 0.15, coil_phase) * (1.0 - smoothstep(0.2, 0.35, coil_phase));

	vec3 col = core_color.rgb * core * 3.0 + sheath_color.rgb * sheath * 1.5 + coil_color.rgb * coil * 2.0;
	float alpha = clamp(core + sheath * 0.8 + coil, 0.0, 1.0);

	ALBEDO = col;
	ALPHA = alpha;
}
