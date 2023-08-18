#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
#endif

const mediump vec3 luminanceWeighting = vec3(0.2125, 0.7154, 0.0721);

uniform float brightness;
uniform float contrast;
uniform float saturation;
uniform vec3 colorTint;

void main()
{
    vec4 texColor = texture2D(CC_Texture0, v_texCoord);
    
    // 亮度
    texColor = vec4((texColor.rgb + vec3(brightness) - vec3(1)), texColor.a);
    
    // 對比度
    texColor = vec4(((texColor.rgb - vec3(0.5)) * contrast + vec3(0.5)), texColor.a);
    
    // 飽和度
    float luminance = dot(texColor.rgb, luminanceWeighting);
    texColor = vec4(mix(vec3(luminance), texColor.rgb, saturation), texColor.a);
    
    // 色調
    texColor = vec4(texColor.rgb * colorTint, texColor.a);
    
    gl_FragColor = texColor;
}
