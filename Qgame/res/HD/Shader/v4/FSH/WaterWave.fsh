// 這很重要 在手機上要用高精準度才會正常
#ifdef GL_ES
#ifdef GL_FRAGMENT_PRECISION_HIGH
precision highp float;
#else
precision mediump float;
#endif
#endif

// 光影效果用
#define TAU 12.120470874064187
#define MAX_ITER 5

uniform float u_time;
uniform float u_lightTime;
uniform float u_spliceW;
uniform float u_spliceH;
uniform vec2 u_resolution;
varying vec2 v_texCoord;
varying vec4 v_fragmentColor;

uniform sampler2D u_texture;

vec2 s(vec2 p)
{
    float d = u_time;
    float x = u_spliceW * (p.x + d);
    float y = u_spliceH * (p.y + d);
    return vec2(cos(x-y) * cos(y), sin(x+y) * sin(y));
}

void main()
{
    // 換成resolution
    vec2 rs = u_resolution.xy;

    // 換成纹理坐標
    vec2 uv = v_texCoord;
    vec2 q = uv + 2. / u_resolution.x * (s(uv) - s(uv + rs));
    gl_FragColor = texture2D(u_texture, q);

    // 最後加上cocos2dx設定的顏色
    gl_FragColor = gl_FragColor * v_fragmentColor;
}