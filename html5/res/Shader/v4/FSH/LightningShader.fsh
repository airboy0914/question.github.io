#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float a;
uniform float b;
uniform float lightWidth;
uniform float secLightWidth;
uniform float gradient;
uniform float brightness;

uniform vec2 textureSize;

uniform float u_time;

uniform sampler2D u_texture;

void main()
{
    //取座標
    vec2 referencePoint = v_texCoord;
    float ratio = 1.;
    //正規化
    if (textureSize.x >= textureSize.y)
    {
        ratio = textureSize.x/textureSize.y;
        referencePoint.x = referencePoint.x * ratio;

        //因為原點在左上 要上下顛倒一下
        referencePoint.y = 1. - referencePoint.y;
    }
    else
    {
        ratio = textureSize.y/textureSize.x;
        referencePoint.y = referencePoint.y * ratio;

        //因為原點在左上 要上下顛倒一下
        referencePoint.y = ratio - referencePoint.y;
    }

    //取樣此fragment的color
    vec4 color = texture2D(u_texture, v_texCoord);
    float totalWidth = lightWidth + gradient;
    float sidePoint = totalWidth * b/a;
    float bonusWidth = sqrt((totalWidth * totalWidth) + (sidePoint * sidePoint));
    //目前中心點 隨時間改變
    vec2 center = vec2(u_time*(ratio + 1.)*(1.5 + bonusWidth) - bonusWidth, 0.);
    //令目前中心點為(0, 0) 參考點的相對座標
    referencePoint = referencePoint - center;

    float lineFunc = abs(a * referencePoint.x + b * referencePoint.y);
    float ran = smoothstep(lightWidth - gradient,lightWidth + gradient, lineFunc);
    color = color*ran + color*vec4(brightness)*(1.-ran)*color.a;

    float secLight = secLightWidth;
    if (secLight != 0.)
    {
        referencePoint += 0.1;
        lineFunc = abs(a * referencePoint.x + b * referencePoint.y);
        ran = smoothstep(secLight - gradient,secLight + gradient, lineFunc);
        color = color*ran + color*vec4(brightness * 2./3.)*(1.-ran)*color.a;
    }

    gl_FragColor = color * v_fragmentColor;
}