attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

uniform mat4 u_animMatrix;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

void main()
{
    gl_Position = CC_MVPMatrix * (u_animMatrix * a_position);
    v_texCoord = a_texCoord;
}