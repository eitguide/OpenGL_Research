precision mediump float;

attribute vec3 aPosition;
attribute vec4 aColor;
attribute vec2 aTexCoord;

varying vec4 vColor;
varying vec2 vTexCoord;

void main() {
    gl_Position = vec4(aPosition / 1.5, 1.0);
    vColor = aColor;
    vTexCoord = aTexCoord;
}
