// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "SwordDisslove"
{
	Properties
	{
		_lambert1_Base_Color("lambert1_Base_Color", 2D) = "white" {}
		_lambert1_Metallic("lambert1_Metallic", 2D) = "white" {}
		_lambert1_Normal_DirectX("lambert1_Normal_DirectX", 2D) = "bump" {}
		_lambert1_Roughness("lambert1_Roughness", 2D) = "white" {}
		[HDR]_ScanColor("ScanColor", Color) = (1,0,0,0)
		_Height("Height", Range( -0.6 , 0.5)) = -0.1134397
		_TextureSample0("花纹", 2D) = "white" {}
		[HDR]_Color0("花纹颜色", Color) = (1,0.9431549,0.361635,0)
		_Float3("整体亮度", Range( 0 , 1)) = 0
		_Float4("花纹亮度", Range( 0 , 1)) = 1
		_DissloveTex("DissloveTex", 2D) = "white" {}
		_DissloveSlider("DissloveSlider", Range( 0 , 1)) = 0.3268124
		_DissloveRimWidth("DissloveRimWidth", Range( 0 , 0.5)) = 0.0818534
		_EmissionTex("EmissionTex", 2D) = "white" {}
		[HDR]_EmissionTexColor("EmissionTexColor", Color) = (2.143547,2.143547,2.143547,0)
		[HideInInspector] _texcoord3( "", 2D ) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Back
		ZWrite On
		Blend SrcAlpha OneMinusSrcAlpha
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
			float2 uv3_texcoord3;
		};

		uniform sampler2D _lambert1_Normal_DirectX;
		uniform float4 _lambert1_Normal_DirectX_ST;
		uniform sampler2D _lambert1_Base_Color;
		uniform float4 _lambert1_Base_Color_ST;
		uniform sampler2D _EmissionTex;
		uniform float4 _EmissionTex_ST;
		uniform float4 _EmissionTexColor;
		uniform float _Height;
		uniform float4 _ScanColor;
		uniform sampler2D _TextureSample0;
		uniform float4 _TextureSample0_ST;
		uniform float4 _Color0;
		uniform float _Float4;
		uniform float _Float3;
		uniform float _DissloveSlider;
		uniform sampler2D _DissloveTex;
		uniform float4 _DissloveTex_ST;
		uniform float _DissloveRimWidth;
		uniform sampler2D _lambert1_Metallic;
		uniform float4 _lambert1_Metallic_ST;
		uniform sampler2D _lambert1_Roughness;
		uniform float4 _lambert1_Roughness_ST;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_lambert1_Normal_DirectX = i.uv_texcoord * _lambert1_Normal_DirectX_ST.xy + _lambert1_Normal_DirectX_ST.zw;
			o.Normal = UnpackNormal( tex2D( _lambert1_Normal_DirectX, uv_lambert1_Normal_DirectX ) );
			float2 uv_lambert1_Base_Color = i.uv_texcoord * _lambert1_Base_Color_ST.xy + _lambert1_Base_Color_ST.zw;
			o.Albedo = tex2D( _lambert1_Base_Color, uv_lambert1_Base_Color ).rgb;
			float2 uv_EmissionTex = i.uv_texcoord * _EmissionTex_ST.xy + _EmissionTex_ST.zw;
			float temp_output_8_0 = ( i.uv3_texcoord3.y + _Height );
			float temp_output_10_0 = step( temp_output_8_0 , 0.48 );
			float2 uv_TextureSample0 = i.uv_texcoord * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
			float2 uv_DissloveTex = i.uv_texcoord * _DissloveTex_ST.xy + _DissloveTex_ST.zw;
			float4 tex2DNode26 = tex2D( _DissloveTex, uv_DissloveTex );
			float temp_output_29_0 = step( _DissloveSlider , ( tex2DNode26.r + _DissloveRimWidth ) );
			o.Emission = ( ( tex2D( _EmissionTex, uv_EmissionTex ) * _EmissionTexColor ) + ( ( ( 1.0 - temp_output_10_0 ) - ( 1.0 - step( temp_output_8_0 , 0.5 ) ) ) * _ScanColor ) + ( ( tex2D( _TextureSample0, uv_TextureSample0 ) * _Color0 * _Float4 ) + ( _Color0 * _Float3 ) ) + ( _ScanColor * ( temp_output_29_0 - step( _DissloveSlider , tex2DNode26.r ) ) ) ).rgb;
			float2 uv_lambert1_Metallic = i.uv_texcoord * _lambert1_Metallic_ST.xy + _lambert1_Metallic_ST.zw;
			o.Metallic = tex2D( _lambert1_Metallic, uv_lambert1_Metallic ).r;
			float2 uv_lambert1_Roughness = i.uv_texcoord * _lambert1_Roughness_ST.xy + _lambert1_Roughness_ST.zw;
			o.Smoothness = tex2D( _lambert1_Roughness, uv_lambert1_Roughness ).r;
			o.Alpha = saturate( ( temp_output_10_0 * temp_output_29_0 ) );
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.customPack1.zw = customInputData.uv3_texcoord3;
				o.customPack1.zw = v.texcoord2;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				surfIN.uv3_texcoord3 = IN.customPack1.zw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.TextureCoordinatesNode;6;-1631.975,428.8624;Inherit;False;2;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;8;-1388.991,440.7571;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;9;-858.6027,434.537;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-1603.134,958.3236;Inherit;False;0;18;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-708.9281,1318.756;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-748.6842,1014.006;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;26;-1545.517,1808.589;Inherit;True;Property;_DissloveTex;DissloveTex;11;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;29;-1050.163,2062.163;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;28;-1013.798,1847.902;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;30;-1259.509,2005.158;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-1610.384,2137.841;Inherit;False;Property;_DissloveRimWidth;DissloveRimWidth;13;0;Create;True;0;0;0;False;0;False;0.0818534;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;10;-945.9053,759.4656;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-535.3362,431.4698;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;14;-527.9096,596.9807;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;15;-112.3212,329.8678;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;896.7939,-6.22653;Inherit;True;Property;_lambert1_Base_Color;lambert1_Base_Color;0;0;Create;True;0;0;0;False;0;False;-1;ce5a4ae887ea1034d8150683435168db;ce5a4ae887ea1034d8150683435168db;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;789.5115,461.5201;Inherit;True;Property;_lambert1_Roughness;lambert1_Roughness;4;0;Create;True;0;0;0;False;0;False;-1;cb311e8b07c615945972c4fdc54a5e3d;cb311e8b07c615945972c4fdc54a5e3d;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;17;-166.9794,610.0588;Inherit;False;Property;_ScanColor;ScanColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;417.2354,1010.147;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;25;-304.1765,1079.268;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;389.209,1950.337;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;34;-19.14175,1741.382;Inherit;False;Property;_DissloveColor;DissloveColor;14;1;[HDR];Create;True;0;0;0;False;0;False;0,0.5207148,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-449.1209,1915.222;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;5;562.8364,375.1523;Inherit;False;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;167.4376,413.1372;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;38;-150.8764,-99.53014;Inherit;True;Property;_EmissionTex;EmissionTex;15;0;Create;True;0;0;0;False;0;False;-1;b4671b56a70b9ad44b9481142abae20d;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;-156.4447,128.757;Inherit;False;Property;_EmissionTexColor;EmissionTexColor;16;1;[HDR];Create;True;0;0;0;False;0;False;2.143547,2.143547,2.143547,0;1,1,1,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;39;188.1196,17.77127;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;3;571.4995,108.4361;Inherit;True;Property;_lambert1_Normal_DirectX;lambert1_Normal_DirectX;3;0;Create;True;0;0;0;False;0;False;3;1e5accce292e39c4b862c71ae2a7ca23;1e5accce292e39c4b862c71ae2a7ca23;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;2;796.276,273.4873;Inherit;True;Property;_lambert1_Metallic;lambert1_Metallic;2;0;Create;True;0;0;0;False;0;False;-1;8e781e44869684542a2f81be6c538192;8e781e44869684542a2f81be6c538192;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;35;655.5974,784.8628;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;36;1096.433,793.528;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;-1201.97,1484.561;Inherit;False;Property;_Float3;整体亮度;9;0;Create;False;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-1269.932,1350.286;Inherit;False;Property;_Float4;花纹亮度;10;0;Create;False;0;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;21;-1213.783,1193.812;Inherit;False;Property;_Color0;花纹颜色;8;1;[HDR];Create;False;0;0;0;False;0;False;1,0.9431549,0.361635,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;18;-1243.218,978.7147;Inherit;True;Property;_TextureSample0;花纹;7;0;Create;False;0;0;0;False;0;False;-1;ee70cde3d43582b4dab7e5971720b403;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;11;-1180.074,572.4623;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-1185.379,716.7535;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.48;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1362.885,133.0988;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;SwordDisslove;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Back;1;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Custom;;Transparent;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;2;5;False;;10;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-1706.763,611.5759;Inherit;False;Property;_Height;Height;6;0;Create;True;0;0;0;False;0;False;-0.1134397;-0.1134397;-0.6;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-1493.294,1712.157;Inherit;False;Property;_DissloveSlider;DissloveSlider;12;0;Create;True;0;0;0;False;0;False;0.3268124;0;0;1;0;1;FLOAT;0
WireConnection;8;0;6;2
WireConnection;8;1;7;0
WireConnection;9;0;8;0
WireConnection;9;1;11;0
WireConnection;22;0;21;0
WireConnection;22;1;23;0
WireConnection;20;0;18;0
WireConnection;20;1;21;0
WireConnection;20;2;24;0
WireConnection;29;0;27;0
WireConnection;29;1;30;0
WireConnection;28;0;27;0
WireConnection;28;1;26;1
WireConnection;30;0;26;1
WireConnection;30;1;31;0
WireConnection;10;0;8;0
WireConnection;10;1;12;0
WireConnection;13;0;9;0
WireConnection;14;0;10;0
WireConnection;15;0;14;0
WireConnection;15;1;13;0
WireConnection;37;0;17;0
WireConnection;37;1;32;0
WireConnection;25;0;20;0
WireConnection;25;1;22;0
WireConnection;33;0;34;0
WireConnection;32;0;29;0
WireConnection;32;1;28;0
WireConnection;5;0;39;0
WireConnection;5;1;16;0
WireConnection;5;2;25;0
WireConnection;5;3;37;0
WireConnection;16;0;15;0
WireConnection;16;1;17;0
WireConnection;39;0;38;0
WireConnection;39;1;40;0
WireConnection;35;0;10;0
WireConnection;35;1;29;0
WireConnection;36;0;35;0
WireConnection;18;1;19;0
WireConnection;0;0;1;0
WireConnection;0;1;3;0
WireConnection;0;2;5;0
WireConnection;0;3;2;1
WireConnection;0;4;4;1
WireConnection;0;9;36;0
ASEEND*/
//CHKSM=940BAFE2F0974596BDC9F8B0FBF0C57715102105