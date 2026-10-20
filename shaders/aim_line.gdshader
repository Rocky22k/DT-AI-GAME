shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 arrow_color : source_color = vec4(0.2, 0.8, 1.0, 0.85);
uniform float arrow_length = 10.0;
uniform float shaft_width = 0.6;
uniform float chevron_speed = 3.0;

void fragment() {
	vec2 p = UV - vec2(0.5, 0.0);
	p.y *= arrow_length;

	float half_w = shaft_width * 0.5;
	float shaft = 1.0 - smoothstep(half_w - 0.05, half_w, abs(p.x));

	float chevron_phase = fract((p.y - abs(p.x) * 0.8) * 0.5 - TIME * chevron_speed);
	float chevron = smoothstep(0.0, 0.2, chevron_phase) * (1.0 - smoothstep(0.3, 0.5, chevron_phase));

	float tip_dist = arrow_length - p.y;
	float tip = 1.0 - smoothstep(0.0, 1.2, abs(p.x) * 2.0 + tip_dist);

	float alpha = max(shaft * (0.3 + 0.7 * chevron), tip);
	alpha *= clamp(p.y * 2.0, 0.0, 1.0);

	ALBEDO = arrow_color.rgb;
	ALPHA = alpha * arrow_color.a;
}
