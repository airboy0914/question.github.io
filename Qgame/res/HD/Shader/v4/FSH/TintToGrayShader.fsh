#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform float tintRatio;
uniform int isReverse;

void main()
{
    vec4 baseColor = texture2D(CC_Texture0, v_texCoord);
    float gray = baseColor.r * 0.299 + baseColor.g * 0.587 + baseColor.b * 0.114;
    vec4 tintToColor = vec4(gray, gray, gray, baseColor.a);
    // 是不是從灰階變彩色
    if(isReverse == 1){
        vec4 temp = baseColor;
        baseColor = tintToColor; 
        tintToColor = temp;
    }

    // 要是比例不對不做事
    if(tintRatio < 1.0 && tintRatio >= 0.0){
        gl_FragColor = vec4(mix(baseColor.xyz, tintToColor.xyz, tintRatio), baseColor.a)* v_fragmentColor;
    }
    else{
        gl_FragColor = tintToColor * v_fragmentColor;
    }
}