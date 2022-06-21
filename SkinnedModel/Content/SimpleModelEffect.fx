﻿#if OPENGL
	#define SV_POSITION POSITION
	#define VS_SHADERMODEL vs_3_0
	#define PS_SHADERMODEL ps_3_0
#else
	#define VS_SHADERMODEL vs_4_0_level_9_1
	#define PS_SHADERMODEL ps_4_0_level_9_1
#endif

matrix World;
matrix WorldViewProjection;
float3 SunOrientation;

Texture2D Texture1;
sampler Sampler1 = sampler_state
{
    Texture = <Texture1>;
};

struct VertexShaderInput
{
	float4 Position : SV_POSITION;
	float3 Normal : NORMAL0;
	float2 Uv : TEXCOORD0;
};

struct VertexShaderOutput
{
	float4 Position : SV_POSITION;
	float3 Normal : NORMAL0;
	float2 Uv : TEXCOORD0;
};

VertexShaderOutput MainVS(in VertexShaderInput input)
{
	VertexShaderOutput output = (VertexShaderOutput)0;

	output.Position = mul(input.Position, WorldViewProjection);
	output.Normal = mul( float4(input.Normal,0), World).xyz;
	output.Uv = input.Uv;

	return output;
}

float4 MainPS(VertexShaderOutput input) : COLOR
{
	float cosTheta = clamp((dot( input.Normal, SunOrientation) *0.5) + 0.5, 0, 1);
	float4 albedo = tex2D(Sampler1, input.Uv);
	float4 result = albedo * cosTheta;
	result.a = 1;
	return result;

}

technique BasicColorDrawing
{
	pass P0
	{
		VertexShader = compile VS_SHADERMODEL MainVS();
		PixelShader = compile PS_SHADERMODEL MainPS();
	}
};