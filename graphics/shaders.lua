local shaders = {}

shaders.general = love.graphics.newShader [[
#pragma language glsl3

extern float time;
extern vec2 resolution;
extern vec3 avgColor;

// noise function taken from https://gist.github.com/patriciogonzalezvivo/670c22f3966e662d2f83

float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 mod289(vec4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
vec4 perm(vec4 x){return mod289(((x * 34.0) + 1.0) * x);}

float noise(vec3 p){
    vec3 a = floor(p);
    vec3 d = p - a;
    d = d * d * (3.0 - 2.0 * d);

    vec4 b = a.xxyy + vec4(0.0, 1.0, 0.0, 1.0);
    vec4 k1 = perm(b.xyxy);
    vec4 k2 = perm(k1.xyxy + b.zzww);

    vec4 c = k2 + a.zzzz;
    vec4 k3 = perm(c);
    vec4 k4 = perm(c + 1.0);

    vec4 o1 = fract(k3 * (1.0 / 41.0));
    vec4 o2 = fract(k4 * (1.0 / 41.0));

    vec4 o3 = o2 * d.z + o1 * (1.0 - d.z);
    vec2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

    return o4.y * d.y + o4.x * (1.0 - d.y);
}

vec3 lerp(vec3 a, vec3 b, vec3 t) {
    return a + (b - a) * t;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = screen_coords.xy / resolution.xy;

    float mult = time * 0.4;

    vec3 col = vec3(
        noise(vec3(time * 0.4, uv)),
        noise(vec3(time * 0.4 + 500.333, uv)),
        noise(vec3(time * 0.4 + 1000.66, uv))
    );
    col = lerp(
        avgColor - 0.15,
        avgColor + 0.15,
        col
    );

    return vec4(col, 1.0);
}
]]



return shaders
