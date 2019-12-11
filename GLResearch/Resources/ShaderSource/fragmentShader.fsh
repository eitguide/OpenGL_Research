precision mediump float;

varying vec4 vColor;
varying vec2 vTexCoord;
uniform sampler2D sTexture;

void main() {
//    gl_FragColor = (texture2D(sTexture, vTexCoord) * vColor);
    gl_FragColor = texture2D(sTexture, vTexCoord);
//    gl_FragColor = vColor;
}
