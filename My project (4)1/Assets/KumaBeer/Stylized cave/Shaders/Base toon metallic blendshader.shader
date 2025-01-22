// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "KumaBeer/Base toon metallic blendshader"
{
	Properties
	{
		_Blendstrength("Blend strength", Float) = 0
		_Blenddistance("Blend distance", Float) = -0.3
		_MainColor("Main Color", Color) = (1,1,1,1)
		[HDR]_Shadowcolor("Shadow color", Color) = (0.3921569,0.454902,0.5568628,1)
		_Main_tiling("Main_tiling", Float) = 1
		_Diffuse("Diffuse(RGB+A)", 2D) = "white" {}
		[Normal]_Normalmap("Normalmap", 2D) = "bump" {}
		_Normalmapscale("Normalmap scale", Float) = 1
		[HDR]_RimColor("Rim Color", Color) = (1,1,1,0)
		_RimStr("Rim Str", Float) = 20
		_Rimoffset("Rim offset", Float) = -10
		_BaseCellSharpness("Base Cell Sharpness", Float) = 0.01
		_BaseCellOffset("Base Cell Offset", Float) = 0
		[Toggle(_USEMASKASMETAL_ON)] _Usemaskasmetal("Use mask as metal", Float) = 0
		_Metalcolormultiplier("Metal color multiplier", Color) = (1,1,1,0)
		_Metalcolorhighrange("Metal color high range", Float) = 18
		_Metalcolorlowrange("Metal color low range", Float) = -14
		_MetallicHighlightrange("Metallic Highlight range", Range( 0 , 1)) = 0
		[Toggle(_USEMASKASMETALRIM_ON)] _Usemaskasmetalrim("Use mask as metal rim", Float) = 0
		[HDR]_Metalrimcolor("Metal rim color", Color) = (1,1,1,0)
		[Toggle(_USEEMISSIVE_ON)] _Useemissive("Use emissive", Float) = 0
		_Emissive_tiling("Emissive_tiling", Float) = 1
		[HDR]_Emissivecolor("Emissive color", Color) = (1,1,1,0)
		_Emissive("Emissive", 2D) = "white" {}
		[Toggle(_USEMASKASEMISSIVEPARALLAX_ON)] _Usemaskasemissiveparallax("Use mask as emissive parallax", Float) = 0
		_Parallaxscale("Parallax scale", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "AlphaTest+0" "IgnoreProjector" = "True" "ForceNoShadowCasting" = "True" "IsEmissive" = "true"  }
		Cull Back
		Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha DstAlpha
		
		ColorMask RGB
		CGPROGRAM
		#include "UnityPBSLighting.cginc"
		#include "UnityStandardUtils.cginc"
		#include "UnityCG.cginc"
		#include "UnityShaderVariables.cginc"
		#pragma target 3.0
		#pragma multi_compile_instancing
		#pragma shader_feature_local _USEEMISSIVE_ON
		#pragma shader_feature_local _USEMASKASMETALRIM_ON
		#pragma shader_feature_local _USEMASKASEMISSIVEPARALLAX_ON
		#pragma shader_feature_local _USEMASKASMETAL_ON
		#define ASE_USING_SAMPLING_MACROS 1
		#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
		#else//ASE Sampling Macros
		#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
		#endif//ASE Sampling Macros

		#pragma surface surf StandardCustomLighting keepalpha 
		struct Input
		{
			float3 worldNormal;
			INTERNAL_DATA
			float2 uv_texcoord;
			float3 worldPos;
			float3 viewDir;
			float4 screenPos;
		};

		struct SurfaceOutputCustomLightingCustom
		{
			half3 Albedo;
			half3 Normal;
			half3 Emission;
			half Metallic;
			half Smoothness;
			half Occlusion;
			half Alpha;
			Input SurfInput;
			UnityGIInput GIData;
		};

		UNITY_DECLARE_TEX2D_NOSAMPLER(_Normalmap);
		uniform float _Main_tiling;
		SamplerState sampler_Normalmap;
		uniform float _Normalmapscale;
		uniform float _RimStr;
		uniform float _Rimoffset;
		uniform float4 _RimColor;
		uniform float _MetallicHighlightrange;
		uniform float4 _Metalrimcolor;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Diffuse);
		SamplerState sampler_Diffuse;
		UNITY_DECLARE_TEX2D_NOSAMPLER(_Emissive);
		uniform float _Emissive_tiling;
		uniform float _Parallaxscale;
		SamplerState sampler_Emissive;
		uniform float4 _Emissivecolor;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Blenddistance;
		uniform float _Blendstrength;
		uniform float4 _MainColor;
		uniform float _BaseCellSharpness;
		uniform float _BaseCellOffset;
		uniform float4 _Shadowcolor;
		uniform float4 _Metalcolormultiplier;
		uniform float _Metalcolorhighrange;
		uniform float _Metalcolorlowrange;

		inline half4 LightingStandardCustomLighting( inout SurfaceOutputCustomLightingCustom s, half3 viewDir, UnityGI gi )
		{
			UnityGIInput data = s.GIData;
			Input i = s.SurfInput;
			half4 c = 0;
			#ifdef UNITY_PASS_FORWARDBASE
			float ase_lightAtten = data.atten;
			if( _LightColor0.a == 0)
			ase_lightAtten = 0;
			#else
			float3 ase_lightAttenRGB = gi.light.color / ( ( _LightColor0.rgb ) + 0.000001 );
			float ase_lightAtten = max( max( ase_lightAttenRGB.r, ase_lightAttenRGB.g ), ase_lightAttenRGB.b );
			#endif
			#if defined(HANDLE_SHADOWS_BLENDING_IN_GI)
			half bakedAtten = UnitySampleBakedOcclusion(data.lightmapUV.xy, data.worldPos);
			float zDist = dot(_WorldSpaceCameraPos - data.worldPos, UNITY_MATRIX_V[2].xyz);
			float fadeDist = UnityComputeShadowFadeDistance(data.worldPos, zDist);
			ase_lightAtten = UnityMixRealtimeAndBakedShadows(data.atten, bakedAtten, UnityComputeShadowFade(fadeDist));
			#endif
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth312 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth312 = abs( ( screenDepth312 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _Blenddistance ) );
			float clampResult314 = clamp( (distanceDepth312*_Blendstrength + _Blenddistance) , 0.0 , 1.0 );
			float2 temp_cast_5 = (_Main_tiling).xx;
			float2 uv_TexCoord21 = i.uv_texcoord * temp_cast_5;
			float2 MainUV22 = uv_TexCoord21;
			float4 tex2DNode45 = SAMPLE_TEXTURE2D( _Diffuse, sampler_Diffuse, MainUV22 );
			float4 appendResult211 = (float4(tex2DNode45.r , tex2DNode45.g , tex2DNode45.b , 0.0));
			float4 temp_output_115_0 = ( _MainColor * appendResult211 );
			float LightType125 = _WorldSpaceLightPos0.w;
			float3 tex2DNode25 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Normalmap, sampler_Normalmap, MainUV22 ), _Normalmapscale );
			float3 WSNormal31 = normalize( (WorldNormalVector( i , tex2DNode25 )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult34 = dot( WSNormal31 , ase_worldlightDir );
			float NdotL36 = dotResult34;
			UnityGI gi72 = gi;
			float3 diffNorm72 = WSNormal31;
			gi72 = UnityGI_Base( data, 1, diffNorm72 );
			float3 indirectDiffuse72 = gi72.indirect.diffuse + diffNorm72 * 0.0001;
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 Lightcolor93 = ase_lightColor;
			float4 temp_output_139_0 = ( saturate( (NdotL36*_BaseCellSharpness + _BaseCellOffset) ) * float4( ( indirectDiffuse72 + ase_lightAtten ) , 0.0 ) * Lightcolor93 );
			float4 lerpResult140 = lerp( _Shadowcolor , float4( 1,1,1,0 ) , temp_output_139_0);
			float4 ifLocalVar142 = 0;
			if( LightType125 == 1.0 )
				ifLocalVar142 = temp_output_139_0;
			else if( LightType125 < 1.0 )
				ifLocalVar142 = lerpResult140;
			float dotResult239 = dot( i.viewDir , tex2DNode25 );
			float Metalmask209 = tex2DNode45.a;
			float4 lerpResult223 = lerp( _Metalcolormultiplier , float4( 1,1,1,0 ) , saturate( ( saturate( (dotResult239*_Metalcolorhighrange + _Metalcolorlowrange) ) + Metalmask209 ) ));
			#ifdef _USEMASKASMETAL_ON
				float4 staticSwitch218 = ( temp_output_115_0 * ifLocalVar142 * lerpResult223 );
			#else
				float4 staticSwitch218 = ( temp_output_115_0 * ifLocalVar142 );
			#endif
			c.rgb = staticSwitch218.rgb;
			c.a = clampResult314;
			return c;
		}

		inline void LightingStandardCustomLighting_GI( inout SurfaceOutputCustomLightingCustom s, UnityGIInput data, inout UnityGI gi )
		{
			s.GIData = data;
		}

		void surf( Input i , inout SurfaceOutputCustomLightingCustom o )
		{
			o.SurfInput = i;
			o.Normal = float3(0,0,1);
			float2 temp_cast_0 = (_Main_tiling).xx;
			float2 uv_TexCoord21 = i.uv_texcoord * temp_cast_0;
			float2 MainUV22 = uv_TexCoord21;
			float3 tex2DNode25 = UnpackScaleNormal( SAMPLE_TEXTURE2D( _Normalmap, sampler_Normalmap, MainUV22 ), _Normalmapscale );
			float3 WSNormal31 = normalize( (WorldNormalVector( i , tex2DNode25 )) );
			float3 ase_worldPos = i.worldPos;
			#if defined(LIGHTMAP_ON) && UNITY_VERSION < 560 //aseld
			float3 ase_worldlightDir = 0;
			#else //aseld
			float3 ase_worldlightDir = normalize( UnityWorldSpaceLightDir( ase_worldPos ) );
			#endif //aseld
			float dotResult34 = dot( WSNormal31 , ase_worldlightDir );
			float NdotL36 = dotResult34;
			float3 ase_worldViewDir = normalize( UnityWorldSpaceViewDir( ase_worldPos ) );
			float dotResult305 = dot( WSNormal31 , ase_worldViewDir );
			float temp_output_222_0 = saturate( (( 1.0 - dotResult305 )*_RimStr + _Rimoffset) );
			#if defined(LIGHTMAP_ON) && ( UNITY_VERSION < 560 || ( defined(LIGHTMAP_SHADOW_MIXING) && !defined(SHADOWS_SHADOWMASK) && defined(SHADOWS_SCREEN) ) )//aselc
			float4 ase_lightColor = 0;
			#else //aselc
			float4 ase_lightColor = _LightColor0;
			#endif //aselc
			float4 Lightcolor93 = ase_lightColor;
			float4 temp_output_144_0 = ( saturate( ( NdotL36 * temp_output_222_0 ) ) * float4( (_RimColor).rgb , 0.0 ) * Lightcolor93 );
			float dotResult239 = dot( i.viewDir , tex2DNode25 );
			float clampResult182 = clamp( ( (dotResult239*0.56 + -0.51) / _MetallicHighlightrange ) , -0.2 , 1.0 );
			float clampResult236 = clamp( ( temp_output_222_0 + clampResult182 ) , 0.1 , 50.0 );
			float4 tex2DNode45 = SAMPLE_TEXTURE2D( _Diffuse, sampler_Diffuse, MainUV22 );
			float Metalmask209 = tex2DNode45.a;
			float4 lerpResult206 = lerp( ( clampResult236 * _Metalrimcolor ) , temp_output_144_0 , Metalmask209);
			#ifdef _USEMASKASMETALRIM_ON
				float4 staticSwitch208 = lerpResult206;
			#else
				float4 staticSwitch208 = temp_output_144_0;
			#endif
			float2 temp_cast_3 = (_Emissive_tiling).xx;
			float2 uv_TexCoord284 = i.uv_texcoord * temp_cast_3;
			float2 Offset279 = ( ( ( 1.0 - tex2DNode45.a ) - 1 ) * i.viewDir.xy * _Parallaxscale ) + uv_TexCoord284;
			#ifdef _USEMASKASEMISSIVEPARALLAX_ON
				float2 staticSwitch248 = Offset279;
			#else
				float2 staticSwitch248 = uv_TexCoord284;
			#endif
			#ifdef _USEEMISSIVE_ON
				float4 staticSwitch242 = ( ( SAMPLE_TEXTURE2D( _Emissive, sampler_Emissive, staticSwitch248 ) * _Emissivecolor ) + staticSwitch208 );
			#else
				float4 staticSwitch242 = staticSwitch208;
			#endif
			o.Emission = staticSwitch242.rgb;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
466;226;1120;560;7851.115;-2001.228;1;True;False
Node;AmplifyShaderEditor.RangedFloatNode;17;-10986.24,1847.379;Inherit;False;Property;_Main_tiling;Main_tiling;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;21;-10750.35,1839.685;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-10407.34,1937.707;Inherit;False;Property;_Normalmapscale;Normalmap scale;8;0;Create;True;0;0;0;False;0;False;1;0.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;22;-10405.89,1852.166;Inherit;False;MainUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;25;-10150.64,1824.343;Inherit;True;Property;_Normalmap;Normalmap;7;1;[Normal];Create;True;0;0;0;False;0;False;-1;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;28;-9763.392,1836.777;Inherit;False;True;1;0;FLOAT3;0,0,1;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;31;-9515.938,1827.58;Inherit;False;WSNormal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.CommentaryNode;35;-11304.38,3569.244;Inherit;False;2128.425;463.7888;Rimlight;15;144;106;95;102;105;85;222;175;306;47;81;301;305;304;303;Rimlight;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;189;-10759.02,4219.957;Inherit;False;1807.351;515.5762;Metal;10;203;236;205;185;182;180;177;178;239;190;Metal;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;30;-11169.95,956.8093;Inherit;False;852.9001;307.4;NdotL;4;36;34;149;32;NdotL;1,1,1,1;0;0
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;190;-10742.18,4263.885;Inherit;False;Tangent;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.ViewDirInputsCoordNode;303;-11236.25,3725.957;Float;False;World;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;304;-11283.29,3614.746;Inherit;False;31;WSNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;305;-11028.05,3620.262;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;32;-11136.4,1003.999;Inherit;False;31;WSNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DotProductOpNode;239;-10490.77,4264.242;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceLightDirHlpNode;149;-11138.45,1087.622;Inherit;False;False;1;0;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;81;-10615.23,3855.92;Float;False;Property;_RimStr;Rim Str;10;0;Create;True;0;0;0;False;0;False;20;20;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;177;-10271.92,4491.313;Inherit;False;Property;_MetallicHighlightrange;Metallic Highlight range;18;0;Create;True;0;0;0;True;0;False;0;0.014;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;178;-10239.19,4263.934;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.56;False;2;FLOAT;-0.51;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;47;-10608.35,3933.737;Float;False;Property;_Rimoffset;Rim offset;11;0;Create;True;0;0;0;False;0;False;-10;-16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;5;-9629.887,1097.007;Inherit;False;944.9617;515.283;Diffuse;6;115;211;108;209;45;38;Diffuse ;1,1,1,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;301;-10820.92,3620.894;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DotProductOpNode;34;-10829.16,1024.798;Inherit;True;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;306;-10371.42,3624.263;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;180;-9958.029,4322.896;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;37;-10999.16,2791.446;Inherit;False;1980.766;417.9499;Shadows;13;142;140;141;138;139;134;135;62;137;46;39;44;308;Shadows;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;-10556.66,1024.181;Float;True;NdotL;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;60;-10891.29,2195.432;Inherit;False;828.4254;361.0605;Comment;2;72;66;Indirect Diffuse;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;38;-9621.889,1371.68;Inherit;False;22;MainUV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;175;-10110.84,3607.958;Inherit;False;36;NdotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;288;-9310.47,3476.357;Inherit;False;Property;_Metalcolorlowrange;Metal color low range;17;0;Create;True;0;0;0;False;0;False;-14;-14;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;45;-9421.001,1345.989;Inherit;True;Property;_Diffuse;Diffuse(RGB+A);6;0;Create;False;0;0;0;False;0;False;-1;None;4a2c5f15f4c0fa24ba7def8d4a94d4e8;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;285;-9938.15,2199.246;Inherit;False;Property;_Emissive_tiling;Emissive_tiling;22;0;Create;True;0;0;0;False;0;False;1;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;222;-10101.23,3694.725;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightColorNode;61;-11105.48,1411.489;Inherit;False;0;3;COLOR;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;289;-9282.879,3382.522;Inherit;False;Property;_Metalcolorhighrange;Metal color high range;16;0;Create;True;0;0;0;False;0;False;18;18;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;182;-9701.488,4426.398;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;-0.2;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-10965.08,3048.253;Float;False;Property;_BaseCellSharpness;Base Cell Sharpness;12;0;Create;True;0;0;0;False;0;False;0.01;2.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;39;-10949.48,3125.583;Float;False;Property;_BaseCellOffset;Base Cell Offset;13;0;Create;True;0;0;0;False;0;False;0;-1.2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;44;-10964.7,2849.535;Inherit;True;36;NdotL;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;66;-10841.29,2339.813;Inherit;False;31;WSNormal;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;252;-9763.469,2557.223;Inherit;False;Property;_Parallaxscale;Parallax scale;26;0;Create;True;0;0;0;False;0;False;0;0.16;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;271;-9829.169,2339.199;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;85;-9893.194,3852.353;Float;False;Property;_RimColor;Rim Color;9;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;2.979561,11.33877,33.24564,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;93;-10875.06,1407.735;Inherit;False;Lightcolor;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;284;-9753.365,2180.924;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.IndirectDiffuseLighting;72;-10598.36,2342.888;Inherit;False;World;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;286;-9047.836,3433.758;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;18;False;2;FLOAT;-14;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;105;-9901.803,3625.329;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LightAttenuation;137;-10376.22,2993.024;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;308;-10565.81,2851.901;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;209;-9088.672,1473.08;Inherit;False;Metalmask;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;185;-9542.694,4309.208;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ParallaxMappingNode;279;-9533.007,2370.293;Inherit;False;Normal;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT3;0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;298;-8811.489,3291.753;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;-8873.861,3796.481;Inherit;False;209;Metalmask;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;-10158.71,2943.678;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SaturateNode;95;-9626.94,3625.243;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;205;-9961.079,4552.168;Float;False;Property;_Metalrimcolor;Metal rim color;20;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0.1839623,0.586952,1,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ClampOpNode;236;-9299.026,4310.018;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0.1;False;2;FLOAT;50;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;106;-9633.296,3787.686;Inherit;False;93;Lightcolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;135;-9934.456,2942.198;Inherit;False;93;Lightcolor;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;102;-9657.107,3705.222;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.WorldSpaceLightPos;124;-11218.29,1296.177;Inherit;False;0;3;FLOAT4;0;FLOAT3;1;FLOAT;2
Node;AmplifyShaderEditor.SaturateNode;62;-10243.5,2851.642;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;309;-8739.919,4250.195;Inherit;False;1792.508;455.2864;;5;314;313;312;311;310;Blend;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;295;-8668.363,3292.175;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;248;-9210.72,2348.214;Inherit;False;Property;_Usemaskasemissiveparallax;Use mask as emissive parallax;25;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;FLOAT2;0,0;False;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT2;0,0;False;6;FLOAT2;0,0;False;7;FLOAT2;0,0;False;8;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;144;-9383.275,3624.727;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;-9093.644,4309.952;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;138;-9939.66,3028.115;Inherit;False;Property;_Shadowcolor;Shadow color;4;1;[HDR];Create;True;0;0;0;False;0;False;0.3921569,0.454902,0.5568628,1;0.06568173,0.06568173,0.1132075,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;125;-10806.29,1298.386;Inherit;False;LightType;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;139;-9751.992,2853.436;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT3;0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;310;-8699.872,4432.783;Inherit;False;Property;_Blenddistance;Blend distance;2;0;Create;True;0;0;0;False;0;False;-0.3;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;141;-9452.323,2843.023;Inherit;False;125;LightType;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;140;-9486.686,3012.365;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;296;-8549.082,3293.354;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;211;-9084.546,1312.528;Inherit;False;COLOR;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;283;-8990.574,3088.29;Inherit;False;Property;_Metalcolormultiplier;Metal color multiplier;15;0;Create;True;0;0;0;False;0;False;1,1,1,0;0.8160377,0.9894933,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;108;-9324.813,1143.347;Float;False;Property;_MainColor;Main Color;3;0;Create;True;0;0;0;False;0;False;1,1,1,1;0.4378779,0.7547169,0.7265536,1;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;246;-8621.023,2892.441;Inherit;False;Property;_Emissivecolor;Emissive color;23;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,1.278431,2,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;206;-8653.528,3750.536;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;240;-8888.931,2700.913;Inherit;True;Property;_Emissive;Emissive;24;0;Create;True;0;0;0;False;0;False;-1;None;2d51c2889b0c3604c8fcaaae331a41a0;True;0;False;white;LockedToTexture2D;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-8378.16,2707.088;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;115;-8920.747,1150.257;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;208;-8419.439,3580.915;Inherit;False;Property;_Usemaskasmetalrim;Use mask as metal rim;19;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;223;-8433.895,3089.984;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;1,1,1,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ConditionalIfNode;142;-9257.075,2849.042;Inherit;True;False;5;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DepthFade;312;-8447.051,4297.667;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;311;-8334.997,4578.112;Inherit;False;Property;_Blendstrength;Blend strength;1;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;313;-7882.407,4469.627;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;219;-8323.018,2112.887;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;-8324.202,2391.208;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;241;-8224.791,2716.516;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StaticSwitch;218;-8048.926,2293.593;Inherit;False;Property;_Usemaskasmetal;Use mask as metal;14;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;314;-7604.545,4469.784;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.StaticSwitch;242;-8034.54,2709.186;Inherit;False;Property;_Useemissive;Use emissive;21;0;Create;True;0;0;0;False;0;False;0;0;0;True;;Toggle;2;Key0;Key1;Create;True;True;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;-7258.699,2126.4;Float;False;True;-1;2;ASEMaterialInspector;0;0;CustomLighting;KumaBeer/Base toon metallic blendshader;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;0;False;Transparent;;AlphaTest;All;18;all;True;True;True;False;0;False;17;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;5;True;2;5;False;-1;10;False;-1;1;5;False;-1;7;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;1;False;-1;0;False;-1;True;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;21;0;17;0
WireConnection;22;0;21;0
WireConnection;25;1;22;0
WireConnection;25;5;23;0
WireConnection;28;0;25;0
WireConnection;31;0;28;0
WireConnection;305;0;304;0
WireConnection;305;1;303;0
WireConnection;239;0;190;0
WireConnection;239;1;25;0
WireConnection;178;0;239;0
WireConnection;301;0;305;0
WireConnection;34;0;32;0
WireConnection;34;1;149;0
WireConnection;306;0;301;0
WireConnection;306;1;81;0
WireConnection;306;2;47;0
WireConnection;180;0;178;0
WireConnection;180;1;177;0
WireConnection;36;0;34;0
WireConnection;45;1;38;0
WireConnection;222;0;306;0
WireConnection;182;0;180;0
WireConnection;271;0;45;4
WireConnection;93;0;61;0
WireConnection;284;0;285;0
WireConnection;72;0;66;0
WireConnection;286;0;239;0
WireConnection;286;1;289;0
WireConnection;286;2;288;0
WireConnection;105;0;175;0
WireConnection;105;1;222;0
WireConnection;308;0;44;0
WireConnection;308;1;46;0
WireConnection;308;2;39;0
WireConnection;209;0;45;4
WireConnection;185;0;222;0
WireConnection;185;1;182;0
WireConnection;279;0;284;0
WireConnection;279;1;271;0
WireConnection;279;2;252;0
WireConnection;279;3;190;0
WireConnection;298;0;286;0
WireConnection;134;0;72;0
WireConnection;134;1;137;0
WireConnection;95;0;105;0
WireConnection;236;0;185;0
WireConnection;102;0;85;0
WireConnection;62;0;308;0
WireConnection;295;0;298;0
WireConnection;295;1;214;0
WireConnection;248;1;284;0
WireConnection;248;0;279;0
WireConnection;144;0;95;0
WireConnection;144;1;102;0
WireConnection;144;2;106;0
WireConnection;203;0;236;0
WireConnection;203;1;205;0
WireConnection;125;0;124;2
WireConnection;139;0;62;0
WireConnection;139;1;134;0
WireConnection;139;2;135;0
WireConnection;140;0;138;0
WireConnection;140;2;139;0
WireConnection;296;0;295;0
WireConnection;211;0;45;1
WireConnection;211;1;45;2
WireConnection;211;2;45;3
WireConnection;206;0;203;0
WireConnection;206;1;144;0
WireConnection;206;2;214;0
WireConnection;240;1;248;0
WireConnection;243;0;240;0
WireConnection;243;1;246;0
WireConnection;115;0;108;0
WireConnection;115;1;211;0
WireConnection;208;1;144;0
WireConnection;208;0;206;0
WireConnection;223;0;283;0
WireConnection;223;2;296;0
WireConnection;142;0;141;0
WireConnection;142;3;139;0
WireConnection;142;4;140;0
WireConnection;312;0;310;0
WireConnection;313;0;312;0
WireConnection;313;1;311;0
WireConnection;313;2;310;0
WireConnection;219;0;115;0
WireConnection;219;1;142;0
WireConnection;120;0;115;0
WireConnection;120;1;142;0
WireConnection;120;2;223;0
WireConnection;241;0;243;0
WireConnection;241;1;208;0
WireConnection;218;1;219;0
WireConnection;218;0;120;0
WireConnection;314;0;313;0
WireConnection;242;1;208;0
WireConnection;242;0;241;0
WireConnection;0;2;242;0
WireConnection;0;9;314;0
WireConnection;0;13;218;0
ASEEND*/
//CHKSM=EA8F8830E0542F8F2EA4B5B658955A6920805ABC