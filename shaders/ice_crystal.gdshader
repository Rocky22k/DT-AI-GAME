shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform vec4 deep_color : source_color = vec4(0.05, 0.3, 0.6, 1.0);
uniform vec4 surface_color : source_color = vec4(0.6, 0.9, 1.0, 1.0);
uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_power = 3.0;
uniform float roughness_val = 0.15;

void fragment() {
	float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), rim_power);

	vec3 base = mix(deep_color.rgb, surface_color.rgb, fresnel * 0.6);
	ALBEDO = base;
	EMISSION = rim_color.rgb * fresnel * 0.8;
	ROUGHNESS = roughness_val;
	METALLIC = 0.1;
}
