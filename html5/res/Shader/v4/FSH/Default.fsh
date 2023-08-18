#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float value;

uniform sampler2D u_texture;

void main() {
    vec4 color = texture2D(u_texture, v_texCoord);
    vec4 boundary = texture2D(u_texture, v_texCoord);
    float alpha = boundary.a;

    gl_FragColor = vec4(color.rgb, alpha) * v_fragmentColor;
}
