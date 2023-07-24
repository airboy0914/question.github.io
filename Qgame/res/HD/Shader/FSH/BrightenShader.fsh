#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float u_time;
uniform float max_bright;

uniform float v;

void main() {
    vec4 color = texture2D(CC_Texture0, v_texCoord);
    vec4 boundary = texture2D(CC_Texture0, v_texCoord);
    float alpha = boundary.a;

    float circleTime = sin(u_time / (2. * v));

    color = (color + vec4(circleTime, circleTime, circleTime, 0.) * max_bright) * alpha;

    if (color[0] < boundary[0])
        color[0] = boundary[0];
    if (color[1] < boundary[1])
        color[1] = boundary[1];
    if (color[2] < boundary[2])
        color[2] = boundary[2];

    gl_FragColor = color * v_fragmentColor;
}