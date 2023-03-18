shader_type canvas_item;

uniform bool fx = false;
//		float t = sin(3000.0 * TIME);
//		COLOR = vec4(t, 1.0-t, 0.9, 1.0);
//		VERTEX.x += sin(20000.0 * TIME) * 24.0;
//		VERTEX.y += sin(300.0 * TIME)* 20.0;
void vertex() {
	if (fx){
		COLOR = vec4(1.0, 0.0, 0.0, 1.0);
	}
}