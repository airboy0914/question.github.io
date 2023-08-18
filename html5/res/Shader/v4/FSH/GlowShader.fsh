#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform vec3 glow_color;
uniform vec2 textureSize;

uniform sampler2D u_texture;

void main() {
   float radius = 4.0;
    
    vec4 accum = vec4(0.0);
    vec4 normal = vec4(0.0);
    
    //normal = texture2D(u_texture, vec2(v_texCoord.x, v_texCoord.y));
    normal = texture2D(u_texture, v_texCoord);
    
    float i = 1.0;
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y + textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y + textureSize.y * i));
    i += 1.0;
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y + textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y + textureSize.y * i));
    i += 1.0;
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y + textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y + textureSize.y * i));
    i += 1.0;
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y - textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x + textureSize.x * i, v_texCoord.y + textureSize.y * i));
    accum += texture2D(u_texture, vec2(v_texCoord.x - textureSize.x * i, v_texCoord.y + textureSize.y * i));

    accum.rgb =  glow_color * accum.a;
    float opacity = ((normal.a) / (radius * 4.0));
    
    normal = (accum * opacity) + (normal * normal.a);
    
    gl_FragColor = v_fragmentColor * normal;
}
