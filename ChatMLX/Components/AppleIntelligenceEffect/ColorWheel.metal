//
//  ColorWheel.metal
//  ChatMLX
//
//  Created by John Mai on 2024/10/6.
//

#include <metal_stdlib>
using namespace metal;

#define M_TWO_PI_F (M_PI_F * 2)

float3 hsv2rgb(float3 c) {
    float4 K = float4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    float3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, saturate(p - K.xxx), c.y);
}

[[ stitchable ]] half4 colorWheel(float2 position, float4 bounds, float brightness) {
    float2 center = position / bounds.zw - 0.5;
    float hue = (atan2(center.y, center.x) + M_PI_F) / M_TWO_PI_F;
    float saturation = min(length(center) * 2.0, 1.0);
    float value = saturate(brightness);
    return half4(half3(hsv2rgb(float3(hue, saturation, value))), 1.0);
}
