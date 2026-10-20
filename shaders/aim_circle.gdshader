shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 circle_color : source_color = vec4(0.8, 0.3, 1.0, 0.85);
uniform float outer_radius = 0.48;
uniform float ring_thickness = 0.04;
uniform float pulse_speed = 4.0;

void fragment() {
	vec2 uv_centered = UV - vec2(0.5);
	float dist = length(uv_centered);

	float ring = smoothstep(outer_radius - ring_thickness, outer_radius - ring_thickness * 0.5, dist)
			   * (1.0 - smoothstep(outer_radius, outer_radius + 0.02, dist));

	float inner_wash = (1.0 - smoothstep(0.0, outer_radius, dist)) * 0.15;
	float angle = atan(uv_centered.y, uv_centered.x);
	float ticks = sin(angle * 8.0 + TIME * pulse_speed) * 0.5 + 0.5;
	float tick_ring = smoothstep(outer_radius * 0.7, outer_radius * 0.72, dist)
					* (1.0 - smoothstep(outer_radius * 0.74, outer_radius * 0.76, dist)) * ticks;

	float alpha = ring + inner_wash + tick_ring * 0.5;
	ALBEDO = circle_color.rgb * (1.0 + ring * 1.5);
	ALPHA = clamp(alpha, 0.0, 1.0) * circle_color.a;
}
