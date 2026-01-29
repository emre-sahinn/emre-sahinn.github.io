uniform float time;
uniform vec3 glintColor;
uniform float glintStrength;
uniform float glintSpeed;
uniform float glintScale;

void getEmission() {
    float f = fract((vUv0.x + vUv0.y) * glintScale + time * glintSpeed);
    float band = 1.0 - abs(f * 2.0 - 1.0);
    band = smoothstep(0.0, 1.0, band);

    dEmission += glintColor * band * glintStrength;
}
