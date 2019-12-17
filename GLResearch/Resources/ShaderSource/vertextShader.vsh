precision mediump float;

attribute vec3 aPosition;
attribute vec4 aColor;
attribute vec2 aTexCoord;

varying vec4 vColor;
varying vec2 vTexCoord;

uniform mat4 uModelViewMatrix;
uniform mat4 uProjectionMatrix;

void main() {
    gl_Position = uProjectionMatrix * uModelViewMatrix * vec4(aPosition, 1.0);
    vColor = aColor;
    vTexCoord = aTexCoord;
}
