shader_type particles;

uniform vec2 targetPos;
uniform float speed = 300.0;
uniform float acelleration = 10.0;
uniform vec2 initial_velocity = vec2(0.0);
uniform vec2 initial_offset = vec2(0.0);

void start() {
	TRANSFORM[3].xy = EMISSION_TRANSFORM[3].xy + initial_offset;
    VELOCITY.xy = initial_velocity;
}

void process() {
	vec2 position = TRANSFORM[3].xy;
    vec2 direction = targetPos - position;
    
    if (length(direction) < 10.0) {
        ACTIVE = false;
    } else {
        VELOCITY.xy = mix(VELOCITY.xy, normalize(direction) * speed, 1.0 - exp(-acelleration * DELTA));
        TRANSFORM[3].xy += VELOCITY.xy * DELTA;
    }
    
}
