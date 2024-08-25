// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "WaterRender"
{
	Properties
	{
		_Float0("DepthDistance", Range( 0.01 , 20)) = 0.01
		[HDR]_UpColor("UpColor", Color) = (0,0,0,0)
		[HDR]_DeepColor("DeepColor", Color) = (0,0,0,0)
		_PosterPower("PosterPower", Range( 1 , 50)) = 1
		_HorizontalDistance("HorizontalDistance", Range( 0 , 1)) = 0.9167411
		_HorizontalColorRamp("HorizontalColorRamp", 2D) = "white" {}
		_RefracScale("RefracScale", Range( 0 , 5)) = 0.2438188
		_FeacSpeed("FeacSpeed", Range( 0 , 1)) = 0.18
		_RefracNoiseTex("RefracNoiseTex", 2D) = "white" {}
		_NoiseIntensity("NoiseIntensity", Range( 0 , 1)) = 0.7487548
		_WaveTex("WaveTex", 2D) = "white" {}
		_Normal1Speed("Normal1Speed", Vector) = (0.1,0.3,0,0)
		_WaveSpeed("WaveSpeed", Vector) = (0.4,0.4,0,0)
		_Normal2Speed("Normal2Speed", Vector) = (0.3,0.2,0,0)
		_WaveNoiseSpeed("WaveNoiseSpeed", Vector) = (0.2,0.2,0,0)
		[HDR]_WaveColor("WaveColor", Color) = (0.1792452,0.4898205,1,0)
		_WaveNoiseTex("WaveNoiseTex", 2D) = "white" {}
		_WaveNoiseIntensity("WaveNoiseIntensity", Range( 0 , 0.5)) = 0.2996074
		_MaskRadius("MaskRadius", Range( 0 , 5)) = 3
		_PoolCenterPos("PoolCenterPos", Vector) = (0.5,0.5,0,0)
		_MaskHardness("MaskHardness", Range( 0.51 , 1)) = 0.51
		_Normal1("Normal1", 2D) = "white" {}
		_Normal2("Normal2", 2D) = "white" {}
		_NormalStrength("NormalStrength", Range( 0 , 1)) = 0.303284
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite Off
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"

			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
				float3 ase_normal : NORMAL;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				float4 ase_texcoord3 : TEXCOORD3;
				float4 ase_texcoord4 : TEXCOORD4;
				float4 ase_texcoord5 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _Normal1;
			uniform float2 _Normal1Speed;
			uniform float4 _Normal1_ST;
			uniform sampler2D _Normal2;
			uniform float2 _Normal2Speed;
			uniform float4 _Normal2_ST;
			uniform float _NormalStrength;
			uniform float4 _WaveColor;
			uniform sampler2D _WaveTex;
			uniform float2 _WaveSpeed;
			uniform float4 _WaveTex_ST;
			uniform sampler2D _WaveNoiseTex;
			uniform float2 _WaveNoiseSpeed;
			uniform float4 _WaveNoiseTex_ST;
			uniform float _WaveNoiseIntensity;
			uniform float _MaskHardness;
			uniform float2 _PoolCenterPos;
			uniform float _MaskRadius;
			uniform float _PosterPower;
			uniform float4 _UpColor;
			uniform float4 _DeepColor;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform sampler2D _RefracNoiseTex;
			uniform float _RefracScale;
			uniform float _FeacSpeed;
			uniform float _NoiseIntensity;
			uniform float _Float0;
			uniform sampler2D _HorizontalColorRamp;
			uniform float4 _HorizontalColorRamp_ST;
			uniform float _HorizontalDistance;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldTangent = UnityObjectToWorldDir(v.ase_tangent);
				o.ase_texcoord2.xyz = ase_worldTangent;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * ( unity_WorldTransformParams.w >= 0.0 ? 1.0 : -1.0 );
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord4.xyz = ase_worldBitangent;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord5 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Normal1 = i.ase_texcoord1.xy * _Normal1_ST.xy + _Normal1_ST.zw;
				float2 panner86 = ( 1.0 * _Time.y * _Normal1Speed + uv_Normal1);
				float2 uv_Normal2 = i.ase_texcoord1.xy * _Normal2_ST.xy + _Normal2_ST.zw;
				float2 panner88 = ( 1.0 * _Time.y * _Normal2Speed + uv_Normal2);
				float3 ase_worldTangent = i.ase_texcoord2.xyz;
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float3 ase_worldBitangent = i.ase_texcoord4.xyz;
				float3x3 ase_tangentToWorldFast = float3x3(ase_worldTangent.x,ase_worldBitangent.x,ase_worldNormal.x,ase_worldTangent.y,ase_worldBitangent.y,ase_worldNormal.y,ase_worldTangent.z,ase_worldBitangent.z,ase_worldNormal.z);
				float3 tangentToWorldPos80 = mul( ase_tangentToWorldFast, ( BlendNormals( UnpackNormal( tex2D( _Normal1, panner86 ) ) , UnpackNormal( tex2D( _Normal2, panner88 ) ) ) * _NormalStrength ) );
				float2 uv_WaveTex = i.ase_texcoord1.xy * _WaveTex_ST.xy + _WaveTex_ST.zw;
				float2 panner55 = ( 1.0 * _Time.y * _WaveSpeed + uv_WaveTex);
				float2 uv_WaveNoiseTex = i.ase_texcoord1.xy * _WaveNoiseTex_ST.xy + _WaveNoiseTex_ST.zw;
				float2 panner65 = ( 1.0 * _Time.y * _WaveNoiseSpeed + uv_WaveNoiseTex);
				float2 texCoord71 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult74 = smoothstep( ( 1.0 - _MaskHardness ) , _MaskHardness , pow( distance( texCoord71 , _PoolCenterPos ) , _MaskRadius ));
				float4 screenPos = i.ase_texcoord5;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_cast_2 = (_RefracScale).xx;
				float2 temp_cast_3 = (( _FeacSpeed * _Time.y )).xx;
				float2 texCoord45 = i.ase_texcoord1.xy * temp_cast_2 + temp_cast_3;
				float2 panner39 = ( 1.0 * _Time.y * float2( 0,0 ) + texCoord45);
				float eyeDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( ase_screenPosNorm + ( (-0.2 + (tex2D( _RefracNoiseTex, panner39 ).r - 0.0) * (1.0 - -0.2) / (1.0 - 0.0)) * _NoiseIntensity ) ).xy ));
				float4 lerpResult12 = lerp( _UpColor , _DeepColor , saturate( ( ( eyeDepth1 - screenPos.w ) / _Float0 ) ));
				float div21=256.0/float((int)_PosterPower);
				float4 posterize21 = ( floor( lerpResult12 * div21 ) / div21 );
				float2 uv_HorizontalColorRamp = i.ase_texcoord1.xy * _HorizontalColorRamp_ST.xy + _HorizontalColorRamp_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float fresnelNdotV23 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode23 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV23, _HorizontalDistance ) );
				float4 lerpResult25 = lerp( posterize21 , tex2D( _HorizontalColorRamp, uv_HorizontalColorRamp ) , fresnelNode23);
				
				
				finalColor = ( float4( tangentToWorldPos80 , 0.0 ) + ( _WaveColor * ( 1.0 - tex2D( _WaveTex, ( panner55 + ( tex2D( _WaveNoiseTex, panner65 ).r * _WaveNoiseIntensity ) ) ).r ) * smoothstepResult74 ) + lerpResult25 + ( UNITY_LIGHTMODEL_AMBIENT * ( 1.0 - posterize21.a ) ) );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	Fallback Off
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.FresnelNode;23;489.5249,414.3447;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;442.6093,226.0824;Inherit;True;Property;_HorizontalColorRamp;HorizontalColorRamp;5;0;Create;True;0;0;0;False;0;False;-1;48ec96fabffd78947a48ca11707cdfaf;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;24;234.6149,641.1397;Inherit;False;Property;_HorizontalDistance;HorizontalDistance;4;0;Create;True;0;0;0;False;0;False;0.9167411;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosterizeNode;21;1089.237,-92.80457;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;812.2712,-380.4491;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;400.6961,-518.765;Inherit;True;Property;_WaveNoiseTex;WaveNoiseTex;16;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;502.2827,-801.1702;Inherit;False;0;53;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;57;546.3435,-668.8218;Inherit;False;Property;_WaveSpeed;WaveSpeed;12;0;Create;True;0;0;0;False;0;False;0.4,0.4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;55;750.8228,-730.4543;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;974.3892,-567.7823;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;63;535.0558,-307.7826;Inherit;False;Property;_WaveNoiseIntensity;WaveNoiseIntensity;17;0;Create;True;0;0;0;False;0;False;0.2996074;0.2996074;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;65;179.9975,-616.3232;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-55.87598,-660.3724;Inherit;False;0;60;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;66;-64.5659,-523.6103;Inherit;False;Property;_WaveNoiseSpeed;WaveNoiseSpeed;14;0;Create;True;0;0;0;False;0;False;0.2,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SamplerNode;53;1105.429,-595.2795;Inherit;True;Property;_WaveTex;WaveTex;10;0;Create;True;0;0;0;False;0;False;-1;dd7dfb44d46e66d4a9db7b6c1b5c2d01;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;32;2468.004,374.7068;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;33;2682.11,590.6453;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;37;2626.745,399.1198;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;2909.535,474.504;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;1956.151,-344.8239;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DistanceOpNode;70;2200.76,-274.4179;Inherit;False;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;69;1988.234,-210.6507;Inherit;False;Property;_PoolCenterPos;PoolCenterPos;19;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PowerNode;72;2389.615,-273.9169;Inherit;False;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;76;2426.467,-167.7879;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;2238.934,-57.14004;Inherit;False;Property;_MaskHardness;MaskHardness;20;0;Create;True;0;0;0;False;0;False;0.51;0;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;1953.574,-76.21687;Inherit;False;Property;_MaskRadius;MaskRadius;18;0;Create;True;0;0;0;False;0;False;3;3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;2623.538,-190.4798;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;2832.545,-474.0895;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;54;1650.129,-434.5552;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;59;2489.887,-600.3844;Inherit;False;Property;_WaveColor;WaveColor;15;1;[HDR];Create;True;0;0;0;False;0;False;0.1792452,0.4898205,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;86;1509.113,-1235.448;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;85;1273.239,-1279.497;Inherit;False;0;82;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;87;1201.3,-1140.482;Inherit;False;Property;_Normal1Speed;Normal1Speed;11;0;Create;True;0;0;0;False;0;False;0.1,0.3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;88;1497.702,-970.3289;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;89;1261.828,-1014.378;Inherit;False;0;83;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;82;1850.772,-1142.865;Inherit;True;Property;_Normal1;Normal1;21;0;Create;True;0;0;0;False;0;False;-1;98985d64e5aa13848952242d8a84bf06;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;83;1830.068,-920.9855;Inherit;True;Property;_Normal2;Normal2;22;0;Create;True;0;0;0;False;0;False;-1;7d70e3d47fcd4234391f938ad3653535;None;True;0;False;white;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;90;1176.651,-877.3994;Inherit;False;Property;_Normal2Speed;Normal2Speed;13;0;Create;True;0;0;0;False;0;False;0.3,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.LerpOp;25;2893.162,68.60422;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;2608.985,-907.2422;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendNormalsNode;84;2207.469,-1056.094;Inherit;True;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;92;2212.324,-815.1816;Inherit;False;Property;_NormalStrength;NormalStrength;23;0;Create;True;0;0;0;False;0;False;0.303284;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.TransformPositionNode;80;2828.106,-910.2968;Inherit;False;Tangent;World;False;Fast;True;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleAddOpNode;35;3423.476,-376.4415;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;125;3635.98,-377.7295;Float;False;True;-1;2;ASEMaterialInspector;100;5;WaterRender;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.RangedFloatNode;22;732.3384,16.4442;Inherit;False;Property;_PosterPower;PosterPower;3;0;Create;True;0;0;0;False;0;False;1;0;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;466.2488,-77.52087;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;14;-16.91653,-304.3166;Inherit;False;Property;_UpColor;UpColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;13;-8.386509,-136.3958;Inherit;False;Property;_DeepColor;DeepColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;10;59.14638,38.82019;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-171.0341,42.18132;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-436.6425,216.8264;Inherit;False;Property;_Float0;DepthDistance;0;0;Create;False;0;0;0;False;0;False;0.01;0.01;0.01;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-692.4579,108.8746;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenDepthNode;1;-711.2023,-27.35461;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-412.1061,44.73907;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-992.8567,-20.69838;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;44;-1965.254,34.12683;Inherit;True;Property;_RefracNoiseTex;RefracNoiseTex;8;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;39;-2247.456,53.89755;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2953.406,26.41669;Inherit;False;Property;_FeacSpeed;FeacSpeed;7;0;Create;True;0;0;0;False;0;False;0.18;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-2898.433,156.1086;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;50;-1445.641,-116.9919;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-1563.657,253.1003;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;9;0;Create;True;0;0;0;False;0;False;0.7487548;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-2692.636,121.6715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-2510.145,-33.89186;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-2960.929,-68.46876;Inherit;False;Property;_RefracScale;RefracScale;6;0;Create;True;0;0;0;False;0;False;0.2438188;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-1601.663,50.11607;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1256.381,52.94199;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
WireConnection;23;3;24;0
WireConnection;21;1;12;0
WireConnection;21;0;22;0
WireConnection;62;0;60;1
WireConnection;62;1;63;0
WireConnection;60;1;65;0
WireConnection;55;0;56;0
WireConnection;55;2;57;0
WireConnection;61;0;55;0
WireConnection;61;1;62;0
WireConnection;65;0;64;0
WireConnection;65;2;66;0
WireConnection;53;1;61;0
WireConnection;32;0;21;0
WireConnection;33;0;32;3
WireConnection;34;0;37;0
WireConnection;34;1;33;0
WireConnection;70;0;71;0
WireConnection;70;1;69;0
WireConnection;72;0;70;0
WireConnection;72;1;73;0
WireConnection;76;0;75;0
WireConnection;74;0;72;0
WireConnection;74;1;76;0
WireConnection;74;2;75;0
WireConnection;58;0;59;0
WireConnection;58;1;54;0
WireConnection;58;2;74;0
WireConnection;54;0;53;1
WireConnection;86;0;85;0
WireConnection;86;2;87;0
WireConnection;88;0;89;0
WireConnection;88;2;90;0
WireConnection;82;1;86;0
WireConnection;83;1;88;0
WireConnection;25;0;21;0
WireConnection;25;1;27;0
WireConnection;25;2;23;0
WireConnection;91;0;84;0
WireConnection;91;1;92;0
WireConnection;84;0;82;0
WireConnection;84;1;83;0
WireConnection;80;0;91;0
WireConnection;35;0;80;0
WireConnection;35;1;58;0
WireConnection;35;2;25;0
WireConnection;35;3;34;0
WireConnection;125;0;35;0
WireConnection;12;0;14;0
WireConnection;12;1;13;0
WireConnection;12;2;10;0
WireConnection;10;0;8;0
WireConnection;8;0;3;0
WireConnection;8;1;9;0
WireConnection;1;0;51;0
WireConnection;3;0;1;0
WireConnection;3;1;2;4
WireConnection;51;0;50;0
WireConnection;51;1;48;0
WireConnection;44;1;39;0
WireConnection;39;0;45;0
WireConnection;41;0;42;0
WireConnection;41;1;43;0
WireConnection;45;0;40;0
WireConnection;45;1;41;0
WireConnection;47;0;44;1
WireConnection;48;0;47;0
WireConnection;48;1;49;0
ASEEND*/
//CHKSM=4F30ED3A764C1C373E659455C071884D5D6F0275