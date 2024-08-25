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
		_WaveSpeed("WaveSpeed", Vector) = (0.4,0.4,0,0)
		_WaveNoiseSpeed("WaveNoiseSpeed", Vector) = (0.2,0.2,0,0)
		[HDR]_WaveColor("WaveColor", Color) = (0.1792452,0.4898205,1,0)
		_WaveNoiseTex("WaveNoiseTex", 2D) = "white" {}
		_WaveNoiseIntensity("WaveNoiseIntensity", Range( 0 , 0.5)) = 0.2996074
		_MaskRadius("MaskRadius", Range( 0 , 5)) = 3
		_PoolCenterPos("PoolCenterPos", Vector) = (0.5,0.5,0,0)
		_MaskHardness("MaskHardness", Range( 0.51 , 1)) = 0.51
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
			#include "UnityShaderVariables.cginc"
			#define ASE_NEEDS_FRAG_WORLD_POSITION


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

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

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord1 = screenPos;
				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord3.xyz = ase_worldNormal;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
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
				float4 screenPos = i.ase_texcoord1;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_cast_1 = (_RefracScale).xx;
				float2 temp_cast_2 = (( _FeacSpeed * _Time.y )).xx;
				float2 texCoord45 = i.ase_texcoord2.xy * temp_cast_1 + temp_cast_2;
				float2 panner39 = ( 1.0 * _Time.y * float2( 0,0 ) + texCoord45);
				float eyeDepth1 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ( ase_screenPosNorm + ( (-0.2 + (tex2D( _RefracNoiseTex, panner39 ).r - 0.0) * (1.0 - -0.2) / (1.0 - 0.0)) * _NoiseIntensity ) ).xy ));
				float4 lerpResult12 = lerp( _UpColor , _DeepColor , saturate( ( ( eyeDepth1 - screenPos.w ) / _Float0 ) ));
				float div21=256.0/float((int)_PosterPower);
				float4 posterize21 = ( floor( lerpResult12 * div21 ) / div21 );
				float2 uv_HorizontalColorRamp = i.ase_texcoord2.xy * _HorizontalColorRamp_ST.xy + _HorizontalColorRamp_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord3.xyz;
				float fresnelNdotV23 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode23 = ( 0.0 + 1.0 * pow( 1.0 - fresnelNdotV23, _HorizontalDistance ) );
				float4 lerpResult25 = lerp( posterize21 , tex2D( _HorizontalColorRamp, uv_HorizontalColorRamp ) , fresnelNode23);
				float2 uv_WaveTex = i.ase_texcoord2.xy * _WaveTex_ST.xy + _WaveTex_ST.zw;
				float2 panner55 = ( 1.0 * _Time.y * _WaveSpeed + uv_WaveTex);
				float2 uv_WaveNoiseTex = i.ase_texcoord2.xy * _WaveNoiseTex_ST.xy + _WaveNoiseTex_ST.zw;
				float2 panner65 = ( 1.0 * _Time.y * _WaveNoiseSpeed + uv_WaveNoiseTex);
				float2 texCoord71 = i.ase_texcoord2.xy * float2( 1,1 ) + float2( 0,0 );
				float smoothstepResult74 = smoothstep( ( 1.0 - _MaskHardness ) , _MaskHardness , pow( distance( texCoord71 , _PoolCenterPos ) , _MaskRadius ));
				
				
				finalColor = ( lerpResult25 + ( UNITY_LIGHTMODEL_AMBIENT * ( 1.0 - posterize21.a ) ) + ( _WaveColor * ( 1.0 - tex2D( _WaveTex, ( panner55 + ( tex2D( _WaveNoiseTex, panner65 ).r * _WaveNoiseIntensity ) ) ).r ) * smoothstepResult74 ) );
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
Node;AmplifyShaderEditor.CommentaryNode;30;-1046.283,-542.6924;Inherit;False;1500.147;703.6882;DeepColor;9;2;3;8;1;10;9;14;13;12;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;29;138.8343,190.9837;Inherit;False;635.369;425.361;HorizontalColor;3;23;27;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.FresnelNode;23;489.5249,414.3447;Inherit;False;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;188.8344,473.7147;Inherit;False;Property;_HorizontalDistance;HorizontalDistance;4;0;Create;True;0;0;0;False;0;False;0.9167411;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;8;-342.5164,-143.5757;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;14;-259.1065,-492.6924;Inherit;False;Property;_UpColor;UpColor;1;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;12;271.1974,-209.5925;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PosterizeNode;21;978.0562,-219.6816;Inherit;False;1;2;1;COLOR;0,0,0,0;False;0;INT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;32;1095.928,15.33006;Inherit;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.OneMinusNode;33;1310.034,231.269;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;25;1357.276,-235.277;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.FogAndAmbientColorsNode;37;1254.669,39.74305;Inherit;False;UNITY_LIGHTMODEL_AMBIENT;0;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;1537.458,115.1276;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;2155.264,-21.12157;Float;False;True;-1;2;ASEMaterialInspector;100;5;WaterRender;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;2;-959.5263,-75.57301;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;27;442.6093,226.0824;Inherit;True;Property;_HorizontalColorRamp;HorizontalColorRamp;5;0;Create;True;0;0;0;False;0;False;-1;48ec96fabffd78947a48ca11707cdfaf;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;51;-1379.796,-430.0037;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SamplerNode;44;-2352.193,-375.1785;Inherit;True;Property;_RefracNoiseTex;RefracNoiseTex;8;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;39;-2634.395,-355.4077;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-3340.345,-382.8886;Inherit;False;Property;_FeacSpeed;FeacSpeed;7;0;Create;True;0;0;0;False;0;False;0.18;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;43;-3285.372,-253.1966;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;50;-1832.58,-526.2972;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;49;-1950.596,-156.205;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;9;0;Create;True;0;0;0;False;0;False;0.7487548;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;-3079.575,-287.6338;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;45;-2897.084,-443.1972;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;40;-3347.868,-477.7741;Inherit;False;Property;_RefracScale;RefracScale;6;0;Create;True;0;0;0;False;0;False;0.2438188;0;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;22;670.683,-105.1925;Inherit;False;Property;_PosterPower;PosterPower;3;0;Create;True;0;0;0;False;0;False;1;0;1;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;47;-1988.602,-359.1893;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.2;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;3;-677.8651,-138.399;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;1;-978.2706,-211.8022;Inherit;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;9;-702.4014,53.32924;Inherit;False;Property;_Float0;DepthDistance;0;0;Create;False;0;0;0;False;0;False;0.01;0.01;0.01;20;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;54;1600.685,-439.7713;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;-1643.32,-356.3633;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;53;1143.898,-595.1696;Inherit;True;Property;_WaveTex;WaveTex;10;0;Create;True;0;0;0;False;0;False;-1;dd7dfb44d46e66d4a9db7b6c1b5c2d01;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;56;549.616,-626.5035;Inherit;False;0;53;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;55;785.4894,-582.4543;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;57;477.6768,-487.4885;Inherit;False;Property;_WaveSpeed;WaveSpeed;11;0;Create;True;0;0;0;False;0;False;0.4,0.4;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;65;230.6641,-654.9899;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;64;-5.209355,-699.0391;Inherit;False;0;60;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;66;16.18481,-575.3573;Inherit;False;Property;_WaveNoiseSpeed;WaveNoiseSpeed;12;0;Create;True;0;0;0;False;0;False;0.2,0.2;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;63;784.3891,-273.7825;Inherit;False;Property;_WaveNoiseIntensity;WaveNoiseIntensity;15;0;Create;True;0;0;0;False;0;False;0.2996074;0.2996074;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;1000.389,-483.7823;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;1042.938,-355.1157;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;60;606.0294,-412.7651;Inherit;True;Property;_WaveNoiseTex;WaveNoiseTex;14;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;59;1719.121,-711.5208;Inherit;False;Property;_WaveColor;WaveColor;13;1;[HDR];Create;True;0;0;0;False;0;False;0.1792452,0.4898205,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;10;-10.20321,-86.70453;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;35;1977.59,-93.72016;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;13;-250.5765,-324.7716;Inherit;False;Property;_DeepColor;DeepColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;58;1911.903,-468.9341;Inherit;True;3;3;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DistanceOpNode;70;2481.249,-452.6236;Inherit;True;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;2168.966,-548.2031;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;72;2739.332,-412.4439;Inherit;True;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;73;2216.531,-187.3524;Inherit;False;Property;_MaskRadius;MaskRadius;16;0;Create;True;0;0;0;False;0;False;3;3;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;74;3189.406,-386.4188;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;76;3023.762,-327.0109;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;2756.625,-210.4708;Inherit;False;Property;_MaskHardness;MaskHardness;18;0;Create;True;0;0;0;False;0;False;0.51;0;0.51;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;69;2196.835,-404.2652;Inherit;False;Property;_PoolCenterPos;PoolCenterPos;17;0;Create;True;0;0;0;False;0;False;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
WireConnection;23;3;24;0
WireConnection;8;0;3;0
WireConnection;8;1;9;0
WireConnection;12;0;14;0
WireConnection;12;1;13;0
WireConnection;12;2;10;0
WireConnection;21;1;12;0
WireConnection;21;0;22;0
WireConnection;32;0;21;0
WireConnection;33;0;32;3
WireConnection;25;0;21;0
WireConnection;25;1;27;0
WireConnection;25;2;23;0
WireConnection;34;0;37;0
WireConnection;34;1;33;0
WireConnection;0;0;35;0
WireConnection;51;0;50;0
WireConnection;51;1;48;0
WireConnection;44;1;39;0
WireConnection;39;0;45;0
WireConnection;41;0;42;0
WireConnection;41;1;43;0
WireConnection;45;0;40;0
WireConnection;45;1;41;0
WireConnection;47;0;44;1
WireConnection;3;0;1;0
WireConnection;3;1;2;4
WireConnection;1;0;51;0
WireConnection;54;0;53;1
WireConnection;48;0;47;0
WireConnection;48;1;49;0
WireConnection;53;1;61;0
WireConnection;55;0;56;0
WireConnection;55;2;57;0
WireConnection;65;0;64;0
WireConnection;65;2;66;0
WireConnection;61;0;55;0
WireConnection;61;1;62;0
WireConnection;62;0;60;1
WireConnection;62;1;63;0
WireConnection;60;1;65;0
WireConnection;10;0;8;0
WireConnection;35;0;25;0
WireConnection;35;1;34;0
WireConnection;35;2;58;0
WireConnection;58;0;59;0
WireConnection;58;1;54;0
WireConnection;58;2;74;0
WireConnection;70;0;71;0
WireConnection;70;1;69;0
WireConnection;72;0;70;0
WireConnection;72;1;73;0
WireConnection;74;0;72;0
WireConnection;74;1;76;0
WireConnection;74;2;75;0
WireConnection;76;0;75;0
ASEEND*/
//CHKSM=4FD7ECD2D70A446BA284CFC248DF8E920A1991E1