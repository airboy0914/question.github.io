#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform int alphaDecrease;
uniform vec2 pixelSize;
uniform vec2 direction;
uniform int radius;
uniform mat4 weights;

uniform sampler2D u_texture;

void main()
{
    vec4 color = texture2D(u_texture, v_texCoord)*weights[0][0];
    vec2 offsetStep = pixelSize*direction;
    for (int i = 1; i < 16; i++)
    {
        vec2 offset = float(i)*offsetStep;
        color += texture2D(u_texture, v_texCoord + offset)*weights[i/4][i - (4 * (i/4))];
        color += texture2D(u_texture, v_texCoord - offset)*weights[i/4][i - (4 * (i/4))];
        if (i >= radius){
            break;
        }
    }

    gl_FragColor = v_fragmentColor * color;

    if (alphaDecrease != 0)
    {
        vec2 referencePoint = v_texCoord;
        float decreaseFactor = 1.;

        float d = distance(referencePoint, vec2(.5, .5));
        decreaseFactor = smoothstep(0.70710678118, .4, d);

        gl_FragColor.a = gl_FragColor.a * decreaseFactor;
    }
}