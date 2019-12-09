precision mediump float;

varying vec4 vColor;
varying vec2 vTexCoord;
uniform sampler2D sTexture;

void main() {
//    gl_FragCo  lor = (texture2D(sTexture, vTexCoord) * vColor);
    gl_FragColor = vec4(1.0) - texture2D(sTexture, vTexCoord);
}
