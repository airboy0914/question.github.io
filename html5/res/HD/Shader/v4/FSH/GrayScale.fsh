#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

uniform sampler2D u_texture;

void main()
{
    vec4 texColor = texture2D(u_texture, v_texCoord);
    float gray = texColor.r * 0.299 + texColor.g * 0.587 + texColor.b * 0.114;
    gl_FragColor = vec4(gray, gray, gray, texColor.a) * v_fragmentColor;
}
