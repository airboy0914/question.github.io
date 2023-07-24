// Refrence:https://stackoverflow.com/questions/46753807/is-photoshop-motion-blur-possible-with-glsl
//          https://github.com/Ricx8/rmStack/blob/master/stackOverflow/ans0001/src/dMotionBlur_v05.frag
#ifdef GL_ES
precision mediump float;
#endif
 
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float blur;
uniform vec2 direction;

const int samples = 20;

uniform sampler2D u_texture;

void main()
{
    vec4 sum = vec4(0.0);
    float total = 0.0;
    
    for (int i = 1; i <= samples; i++){
        float floatI = float(i);
        float counter = float(samples) - floatI + 1.0;
        float p = floatI/float(samples);
        float tO = (p * 0.1783783784) + 0.0162162162;
        total += tO;
        sum += texture2D(u_texture, v_texCoord - (direction * counter * blur)) * tO;
    }
    
    for (int i = samples; i >= 1; i--){
        float floatI = float(i);
        float counter = float(samples) - floatI + 1.0;
        float p = floatI/float(samples);
        float tO = (p * 0.1783783784) + 0.0162162162;
        total += tO;
        sum += texture2D(u_texture, v_texCoord + (direction * counter * blur)) * tO;
    }
    
    gl_FragColor =  v_fragmentColor * (sum/total);

}
