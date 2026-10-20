shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform vec4 floor_color : source_color = vec4(0.03, 0.03, 0.05, 1.0);
uniform vec4 grid_color : source_color = vec4(0.1, 0.3, 0.5, 0.4);
uniform vec4 border_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);
uniform float arena_radius = 24.0;

varying vec3 world_pos;

void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 pos = world_pos.xz;
	float dist = length(pos);

	vec2 grid = abs(fract(pos * 0.5 - 0.5) - 0.5) / fwidth(pos * 0.5);
	float line = 1.0 - min(min(grid.x, grid.y), 1.0);

	float border = smoothstep(arena_radius - 0.4, arena_radius, dist)
				 * (1.0 - smoothstep(arena_radius + 0.2, arena_radius + 0.6, dist));

	vec3 col = floor_color.rgb + grid_color.rgb * (line * 0.15);
	ALBEDO = col;
	EMISSION = border_color.rgb * border * 3.0;
	ROUGHNESS = 0.25;
	METALLIC = 0.2;
}
