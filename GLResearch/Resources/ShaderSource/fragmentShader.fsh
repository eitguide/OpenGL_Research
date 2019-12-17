precision mediump float;

varying vec4 vColor;
varying vec2 vTexCoord;
uniform sampler2D sTexture1;
uniform sampler2D sTexture2;

void main() {
//    gl_FragColor = (texture2D(sTexture, vTexCoord) * vColor);
//    gl_FragColor = vColor * texture2D(sTexture, vTexCoord);
//    gl_FragColor = vColor;
    
//    lowp vec4 base = texture2D(sTexture1, vTexCoord);
//    lowp vec4 overlay = texture2D(sTexture2, vTexCoord);
//
//    mediump float r;
//    if (overlay.r * base.a + base.r * overlay.a >= overlay.a * base.a) {
//      r = overlay.a * base.a + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);
//    } else {
//      r = overlay.r + base.r;
//    }
//
//    mediump float g;
//    if (overlay.g * base.a + base.g * overlay.a >= overlay.a * base.a) {
//      g = overlay.a * base.a + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);
//    } else {
//      g = overlay.g + base.g;
//    }
//
//    mediump float b;
//    if (overlay.b * base.a + base.b * overlay.a >= overlay.a * base.a) {
//      b = overlay.a * base.a + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);
//    } else {
//      b = overlay.b + base.b;
//    }
//
//    mediump float a = overlay.a + base.a - overlay.a * base.a;
//
//    gl_FragColor = vec4(r, g, b, a);
//
    
    
    lowp vec4 color0 = texture2D(sTexture1, vTexCoord);
    lowp vec4 color1 = texture2D(sTexture2, vTexCoord);
    gl_FragColor = mix(color0, color1, color1.a);
}
