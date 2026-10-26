// Enchant parlama efekti - 3D meshler (emissivePS chunk degistirir)
// Motorun varsayilan emission hesabi + uzerine kayan parlama bandi.
// Motor 2.22 ve 2.23 ile uyumlu: surume ozel doku bias yer tutucusu kullanilmaz
// (2.22 de o yer tutucu yok; derleme hatasi verip resmi gorunmez yapiyordu).
#ifndef MESH_COLOR
    uniform vec3 material_emissive;
#endif
uniform float material_emissiveIntensity;

uniform float time;
uniform vec3 glintColor;
uniform float glintStrength;
uniform float glintSpeed;
uniform float glintScale;

void getEmission() {
    // --- materyalin kendi emission degeri (motorun varsayilan kodu) ---
    #ifdef MESH_COLOR
        dEmission = mesh_color.rgb * material_emissiveIntensity;
    #else
        dEmission = material_emissive * material_emissiveIntensity;
    #endif
    #ifdef STD_EMISSIVE_TEXTURE
        dEmission *= {STD_EMISSIVE_TEXTURE_DECODE}(texture2D({STD_EMISSIVE_TEXTURE_NAME}, {STD_EMISSIVE_TEXTURE_UV})).{STD_EMISSIVE_TEXTURE_CHANNEL};
    #endif
    #ifdef STD_EMISSIVE_VERTEX
        dEmission *= saturate(vVertexColor.{STD_EMISSIVE_VERTEX_CHANNEL});
    #endif

    // --- parlama icin UV (dokusu olmayan materyalde de derlenir) ---
    #ifdef STD_EMISSIVE_TEXTURE
        vec2 glintUv = {STD_EMISSIVE_TEXTURE_UV};
    #elif defined(STD_DIFFUSE_TEXTURE)
        vec2 glintUv = {STD_DIFFUSE_TEXTURE_UV};
    #else
        vec2 glintUv = gl_FragCoord.xy * 0.01;
    #endif

    // --- kayan yumusak bant ---
    float f = fract((glintUv.x + glintUv.y) * glintScale + time * glintSpeed);
    float band = 1.0 - abs(f * 2.0 - 1.0);
    band = smoothstep(0.0, 1.0, band);

    dEmission += glintColor * band * glintStrength;
}
