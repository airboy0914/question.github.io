#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float u_time;
uniform float v;
uniform int isSelectedColor;
uniform int hsvIndex;
uniform float maxValue;
uniform float minValue;

uniform sampler2D u_texture;

vec3 rgb2hsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d/ (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void main() {
    vec4 color = texture2D(u_texture, v_texCoord);
    vec4 boundary = texture2D(u_texture, v_texCoord);
    float alpha = boundary.a;
    vec3 hsv = rgb2hsv(color.rgb);
    vec3 hsvOrigin = rgb2hsv(boundary.rgb);

    float circleTime = sin(u_time / (v));
    
    if(hsvIndex == 0){
        //H 色相
        hsv[0] += circleTime;
        if(hsv[0] > maxValue)
            hsv[0] = maxValue;
        else if(hsv[0] < minValue)
            hsv[0] = minValue;
    }else if(hsvIndex == 1){
        //S 飽和度
        hsv[1] += circleTime;
        if(hsv[1] > maxValue)
            hsv[1] = maxValue;
        else if(hsv[1] < minValue)
            hsv[1] = minValue;
    }else if(hsvIndex == 2){
        //V 亮度
        hsv[2] += circleTime;
        if(hsv[2] > maxValue)
            hsv[2] = maxValue;
        else if(hsv[2] < minValue)
            hsv[2] = minValue;
    }
    
    color.rgb = hsv2rgb(hsv).rgb;
    color = color * alpha;
    gl_FragColor = color * v_fragmentColor;
}
