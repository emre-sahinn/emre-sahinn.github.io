uniform sampler2D texture_msdfMap;

uniform float font_sdfIntensity;
uniform float font_pxrange;

uniform float time;
uniform float rainbowOutline;
uniform vec4 rainbowColors[10];
uniform int rainbowCount;

float median(float r, float g, float b) {
    return max(min(r, g), min(max(r, g), b));
}

vec3 getRainbowColor(float value) {
    if (rainbowCount <= 0) return vec3(1.0);

    float t = fract(value);
    float scaled = t * float(rainbowCount);
    int index1 = int(floor(scaled)) % rainbowCount;
    int index2 = (index1 + 1) % rainbowCount;
    float localT = fract(scaled);

    return mix(rainbowColors[index1].rgb, rainbowColors[index2].rgb, localT);
}

vec4 applyMsdf(vec4 color) {
    // gelen color premultiplied; sadece alfasini koruyoruz
    float srcAlpha = color.a;

    vec3 tsample = texture2D(texture_msdfMap, vUv0).rgb;
    float sigDist = median(tsample.r, tsample.g, tsample.b);

    // v2.20+ anti-aliasing: atlas spread'inden ekran pikseli araligi
    vec2 unitRange = vec2(font_pxrange) / vec2(textureSize(texture_msdfMap, 0));
    float screenPxRange = max(0.5 * dot(unitRange, 1.0 / max(fwidth(vUv0), vec2(1e-6))), 2.5);

    float edge = 0.5 - 0.5 * font_sdfIntensity;

    float inside  = clamp(screenPxRange * (sigDist - edge) + 0.5, 0.0, 1.0);
    float outline = clamp(screenPxRange * (sigDist + rainbowOutline - edge) + 0.5, 0.0, 1.0);

    vec3 rainbow = getRainbowColor(-gl_FragCoord.x / 500.0 + time);

    // siyah outline arkada, rainbow dolgu onde -> premultiplied cikti
    // outline siyah oldugu icin renge katkisi yok, sadece alfayi genisletir
    float a = outline * srcAlpha;
    vec3 rgb = rainbow * inside * srcAlpha;

    return vec4(rgb, a);
}