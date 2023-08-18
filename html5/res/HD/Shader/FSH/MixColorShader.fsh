#ifdef GL_ES
    precision mediump float;
#else
    #define lowp
    #define mediump
    #define highp
#endif

varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;

uniform lowp vec3 mixColor;
uniform float mixOpacity;
uniform float mixRate;

void main()
{
    // 先取原本的 rgba
    vec4 originColor = texture2D(CC_Texture0, v_texCoord);

    // 依照比例 混合兩種 rgb
    vec4 resultColor = mix(originColor, vec4(mixColor, mixOpacity), mixRate) * originColor.a;

    gl_FragColor = resultColor * v_fragmentColor;
}