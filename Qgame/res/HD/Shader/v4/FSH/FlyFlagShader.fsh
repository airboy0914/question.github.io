/**
 * Created by Miao on 2019/4/1.
 * 盡量不要用texturePack包好的SpriteFrame作成的Sprite來套用shader
 * 不然上下左右可能會反過來
 */

#define PI 3.14159265359
#ifdef GL_ES
precision mediump float;
#endif
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float decayTime;
uniform float remainTime;

uniform float contrast;
uniform float waveNum;
uniform int style;
uniform int isHorizon;
uniform vec2 textureSize;

uniform float u_time;

uniform sampler2D u_texture;

void main()
{
    //取座標
    vec2 referencePoint = v_texCoord;
    vec2 uv = v_texCoord;
    float ratio = 1.;
    vec2 flyDir = uv;
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

    if (isHorizon == 0)
    {
        //如果是垂直的旗子 飄揚方向要改變一下
        flyDir.x = uv.y;
        flyDir.y = uv.x;
        float tmp = referencePoint.x;
        if (textureSize.x >= textureSize.y)
            referencePoint.x = 1. - referencePoint.y;
        else
            referencePoint.x = ratio - referencePoint.y;
        referencePoint.y = tmp;
    }

    float lineFunc = -referencePoint.x + referencePoint.y;
    if (style == 1)
        lineFunc = lineFunc - log(flyDir.x);
    else if (style == 2)
        lineFunc = lineFunc + log(abs(flyDir.x - 1.4));
    else if (style == 3)
        lineFunc = lineFunc - exp(-1.0+referencePoint.x);
    else if (style == 4)
        lineFunc = lineFunc - exp(-1.0+referencePoint.x) + exp(-referencePoint.y);

    float decayScale = 1.;
    if (decayTime >= 0.)
        decayScale = remainTime/decayTime;

    float vibration = u_time + lineFunc * waveNum;
    uv.x += decayScale*(flyDir.x * sin(vibration) * 0.03);
    uv.y += decayScale*(flyDir.x * cos(vibration) * 0.03);

    if (uv.y <= 1. && uv.x <= 1. && uv.y >= 0. && uv.x >= 0.)
    {
        decayScale = 0.;
        if (decayTime >= 0.)
            decayScale = (1. - contrast) - (((1. - contrast)/decayTime) * remainTime);

        float shadow = (contrast + decayScale) - (1. - contrast - decayScale)*(sin(vibration));
        vec4 color = texture2D(u_texture, uv);
        gl_FragColor = vec4(color.rgb * shadow, color.a) * v_fragmentColor;
    }
    else
        gl_FragColor = vec4(0.);
}