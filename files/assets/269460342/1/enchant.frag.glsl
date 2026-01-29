uniform float time;
uniform vec3 glintColor;
uniform float glintStrength;
uniform float glintSpeed;
uniform float glintScale;

float glintBand(vec2 uv) {
    float f = fract((uv.x + uv.y) * glintScale + time * glintSpeed);
    float band = 1.0 - abs(f * 2.0 - 1.0);
    return smoothstep(0.0, 1.0, band);
}

#ifdef UI_SHADER
void getAlbedo() {
    if (dAlpha < 0.01) discard;
    float band = glintBand(vUv0);
    dAlbedo += glintColor * band * glintStrength;
}
#else
void getEmission() {
    float band = glintBand(vUv0);
    dEmission += glintColor * band * glintStrength;
}
#endif
