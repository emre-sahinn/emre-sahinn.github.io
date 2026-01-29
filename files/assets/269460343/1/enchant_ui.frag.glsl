uniform float time; 
uniform vec3 glintColor; 
uniform float glintStrength; 
uniform float glintSpeed; 
uniform float glintScale; 

void getAlbedo() { 
    if (dAlpha < 0.01) discard; 
    vec2 uv = vUv0; 
    float f = fract((uv.x + uv.y) * glintScale + time * glintSpeed); 
    // Yumuşak bant (soft band) 
    float band = 1.0 - abs(f * 2.0 - 1.0); // Kenarları daha da soften 
    band = smoothstep(0.0, 1.0, band); 
    dAlbedo += glintColor * band * glintStrength; 
}