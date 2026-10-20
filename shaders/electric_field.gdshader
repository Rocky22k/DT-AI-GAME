shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 lightning_color : source_color = vec4(0.7, 0.3, 1.0, 0.95);
uniform float rotation_speed = 2.0;

void fragment() {
	vec2 p = UV - vec2(0.5);
	float r = length(p);
	float a = atan(p.y, p.x);

	float arc1 = sin(a * 12.0 + TIME * rotation_speed * 3.0 + r * 20.0);
	float arc2 = cos(a * 8.0 - TIME * rotation_speed * 4.0 - r * 15.0);
	float arc_field = smoothstep(0.7, 0.95, abs(arc1 * arc2));

	float ring_mask = smoothstep(0.48, 0.44, r) * smoothstep(0.05, 0.15, r);
	float alpha = arc_field * ring_mask;

	ALBEDO = lightning_color.rgb * (1.5 + arc_field * 2.0);
	ALPHA = alpha * lightning_color.a;
}
