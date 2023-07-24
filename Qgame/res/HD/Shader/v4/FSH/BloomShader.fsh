#ifdef GL_ES
precision mediump float;
#endif

#define PI 3.14159265359

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform float brightness;
uniform vec2 textureSize;

uniform sampler2D u_texture;

void main() {
    vec4 originalTextureColor = texture2D(u_texture, v_texCoord);
    vec3 resultColor = vec3(0.0);
    vec3 brightnessColor[9];

    // 計算3*3的像素質，需要考慮環境光的影響
    for (int i = 0;i<9;++i){
        vec3 textureColor = texture2D(u_texture, v_texCoord + vec2(textureSize.x * (float(i/4)-1.0), textureSize.y * (float(i - (4 * (i/4))) -1.0))).rgb;
        vec3 ambientColor = v_fragmentColor.rgb * textureColor;
        brightnessColor[i] = ambientColor;

        if (i==4){
            resultColor = ambientColor;
        }
    }

    // 模糊權重矩陣
    mat3 weight;
    weight[0][0] = 0.05;
    weight[0][1] = 4.0;
    weight[0][2] = 0.05;
    weight[1][0] = 4.0;
    weight[1][1] = 50.0;
    weight[1][2] = 4.0;
    weight[2][0] = 0.05;
    weight[2][1] = 4.0;
    weight[2][2] = 0.05;
    for (int row = 0;row<3;++row){
        for (int col = 0;col<3;++col){
            weight[row][col] /= 68.0;
        }
    }

    // 利用模糊權重矩陣來計算出此點的顏色
    vec3 blurColor = vec3(0.0);
    for (int row = 0;row<3;++row){
        for (int col = 0;col<3;++col){
            blurColor += weight[row][col] * brightnessColor[row * 3 + col];
        }
    }

    // 加上計算模糊之後的像素點
    resultColor +=  blurColor;

    // HDR
    resultColor = vec3(1.0) - exp(-(resultColor) * brightness);
    resultColor = pow(resultColor, vec3(1.0 / 1.8));

    gl_FragColor =  vec4(resultColor, originalTextureColor.a);
}
