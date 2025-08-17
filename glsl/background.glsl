precision mediump float;

uniform float u_time;      // 経過時間
uniform vec2 u_resolution; // 画面解像度

const float radius = 0.2;    // 水玉半径
const float speed = 0.1;      // スクロール速度
const float spacing = 0.15;   // 水玉間隔

// 水玉カラー（パステル系）
vec3 pastelColors[3];
void initColors() {
    pastelColors[0] = vec3(1.0, 0.8, 0.6); // 柔らかオレンジ
    pastelColors[1] = vec3(0.6, 0.9, 1.0); // 水色
    pastelColors[2] = vec3(0.8, 1.0, 0.7); // 黄緑
}

void main() {
    vec2 uv = gl_FragCoord.xy / u_resolution.xy;
    uv.x *= u_resolution.x / u_resolution.y;

    vec3 color = vec3(1.0); // 背景白

    initColors();

    // 無限格子を右上方向にスクロール
    vec2 offset = u_time * speed * vec2(1.0, 1.0);

    vec2 gridUV = uv / spacing - offset;
    vec2 f = fract(gridUV);

    float dist = distance(f, vec2(0.5));

    // 円形マスクで柔らかく描画
    float circle = smoothstep(radius, radius - 0.01, dist);

    // 水玉のカラーを UV で選択（格子状で色が変わる）
    int idx = int(mod(floor(gridUV.x + gridUV.y), 3.0));
    vec3 dotColor = (idx == 0) ? vec3(1.0, 0.8, 0.6) :
                (idx == 1) ? vec3(0.6, 0.9, 1.0) :
                             vec3(0.8, 1.0, 0.7);


    color = mix(color, dotColor, circle);

    gl_FragColor = vec4(color, 1.0);
}
