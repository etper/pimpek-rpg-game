shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float outline_size = 1.0;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);

	if (tex.a > 0.0) {
		COLOR = tex;
		return;
	}

	vec2 p = TEXTURE_PIXEL_SIZE * outline_size;

	float a = 0.0;
	a += texture(TEXTURE, UV + vec2( p.x, 0.0)).a;
	a += texture(TEXTURE, UV + vec2(-p.x, 0.0)).a;
	a += texture(TEXTURE, UV + vec2(0.0,  p.y)).a;
	a += texture(TEXTURE, UV + vec2(0.0, -p.y)).a;
	a += texture(TEXTURE, UV + vec2( p.x,  p.y)).a;
	a += texture(TEXTURE, UV + vec2(-p.x,  p.y)).a;
	a += texture(TEXTURE, UV + vec2( p.x, -p.y)).a;
	a += texture(TEXTURE, UV + vec2(-p.x, -p.y)).a;

	if (a > 0.0) {
		COLOR = outline_color;
	} else {
		COLOR = vec4(0.0);
	}
}