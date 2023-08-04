precision highp float;
varying lowp vec2 TexCoordOut;
uniform sampler2D Texture;
uniform float Time;

void main(void) {
    //s=v0*t + 1/2 * a * t * t
    float duration = 10.0;
    float v0 = 0.1;
    float a = 10.0;
    float t = mod(Time, duration) / duration;
    
    float s = v0 * t + 0.5 * a * t * t;
    vec4 mask = texture2D(Texture, TexCoordOut / (1.0 + s));
//    if(mask.a < 0.1)
//        discard;
    gl_FragColor = mask;
//    gl_FragColor = vec4(mask.rgb, 0.5);
}
