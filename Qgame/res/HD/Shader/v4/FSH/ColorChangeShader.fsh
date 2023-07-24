#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

// 一般變色
uniform mat4 colorNeedChangeMat;
uniform mat4 colorChangeToMat;
uniform float deviation;

// 灰階漸層變色
uniform int isGrayScaleColorEnabled;
uniform vec3 grayScaleColorChangeTo;

uniform sampler2D u_texture;

void main()
{
    // 取樣此fragment的color
    vec4 color = texture2D(u_texture, v_texCoord);
    vec3 to3F = vec3(255.0, 255.0, 255.0);
    vec3 colorNeedChangeVector[5];
    vec3 colorChangeToVector[5];

    colorNeedChangeVector[0] = vec3(colorNeedChangeMat[0][0], colorNeedChangeMat[0][1], colorNeedChangeMat[0][2]);
    colorNeedChangeVector[1] = vec3(colorNeedChangeMat[0][3], colorNeedChangeMat[1][0], colorNeedChangeMat[1][1]);
    colorNeedChangeVector[2] = vec3(colorNeedChangeMat[1][2], colorNeedChangeMat[1][3], colorNeedChangeMat[2][0]);
    colorNeedChangeVector[3] = vec3(colorNeedChangeMat[2][1], colorNeedChangeMat[2][2], colorNeedChangeMat[2][3]);
    colorNeedChangeVector[4] = vec3(colorNeedChangeMat[3][0], colorNeedChangeMat[3][1], colorNeedChangeMat[3][2]);

    colorChangeToVector[0] = vec3(colorChangeToMat[0][0], colorChangeToMat[0][1], colorChangeToMat[0][2]);
    colorChangeToVector[1] = vec3(colorChangeToMat[0][3], colorChangeToMat[1][0], colorChangeToMat[1][1]);
    colorChangeToVector[2] = vec3(colorChangeToMat[1][2], colorChangeToMat[1][3], colorChangeToMat[2][0]);
    colorChangeToVector[3] = vec3(colorChangeToMat[2][1], colorChangeToMat[2][2], colorChangeToMat[2][3]);
    colorChangeToVector[4] = vec3(colorChangeToMat[3][0], colorChangeToMat[3][1], colorChangeToMat[3][2]);

    // 一般變色
    for (int i = 0; i < 5; i++)
    {
        vec3 colorNeedChange = colorNeedChangeVector[i] / to3F;
        vec3 colorChangeTo = colorChangeToVector[i] / to3F;
        if (color[0] > colorNeedChange[0] - deviation &&
       	    color[1] > colorNeedChange[1] - deviation &&
            color[2] > colorNeedChange[2] - deviation &&
            color[0] < colorNeedChange[0] + deviation &&
            color[1] < colorNeedChange[1] + deviation &&
            color[2] < colorNeedChange[2] + deviation)
        {
            color.rgb = vec3(colorChangeTo[0], colorChangeTo[1], colorChangeTo[2]);
            break;
        }
    }

    // 灰階漸層變色
    if (isGrayScaleColorEnabled == 1 &&
        color[0] > color[1] - 0.01 &&
        color[0] < color[1] + 0.01 &&
        color[0] > color[2] - 0.01 &&
        color[0] < color[2] + 0.01 &&
        color[1] > color[2] - 0.01 &&
        color[1] < color[2] + 0.01)
    {
        vec3 grayColorChangeTo3F = (grayScaleColorChangeTo / to3F);
        color = color * vec4(grayColorChangeTo3F.r, grayColorChangeTo3F.g, grayColorChangeTo3F.b, 1);
    }

    gl_FragColor = color * v_fragmentColor;
}
