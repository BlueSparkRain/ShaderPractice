// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyASEShader/SoftDisslove"
{
	Properties
	{
		_MianTex("MianTex", 2D) = "white" {}
		_DepthDistance("DepthDistance", Range( 0 , 10)) = 0
		_DissloveTex("DissloveTex", 2D) = "white" {}
		[HDR]_Color("Color ", Color) = (1,1,1,0)
		[HDR]_MainColor("MainColor", Color) = (1,1,1,1)
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
		Cull Off
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
			#define ASE_NEEDS_FRAG_COLOR


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_color : COLOR;
				float4 ase_texcoord1 : TEXCOORD1;
				float4 ase_texcoord2 : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _MianTex;
			uniform float4 _MianTex_ST;
			uniform float4 _MainColor;
			uniform sampler2D _DissloveTex;
			uniform float4 _DissloveTex_ST;
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _DepthDistance;
			uniform float4 _Color;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				
				o.ase_color = v.color;
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
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
				float2 uv_MianTex = i.ase_texcoord1.xy * _MianTex_ST.xy + _MianTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MianTex, uv_MianTex );
				float3 temp_output_11_0 = (( i.ase_color * tex2DNode1 * _MainColor )).rgb;
				float2 uv_DissloveTex = i.ase_texcoord1.xy * _DissloveTex_ST.xy + _DissloveTex_ST.zw;
				float4 tex2DNode8 = tex2D( _DissloveTex, uv_DissloveTex );
				float4 appendResult23 = (float4(temp_output_11_0 , ( i.ase_color.a * tex2DNode1.a * saturate( ( tex2DNode8.r + 1.0 + ( -2.0 * i.ase_color.a ) ) ) )));
				float4 screenPos = i.ase_texcoord2;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth2 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
				float distanceDepth2 = abs( ( screenDepth2 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _DepthDistance ) );
				
				
				finalColor = ( appendResult23 * saturate( distanceDepth2 ) * _Color );
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
Node;AmplifyShaderEditor.DynamicAppendNode;12;421.1347,-197.2682;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-582.7499,269.8624;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-782.2684,450.9053;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1014.573,281.144;Inherit;False;Constant;_Float0;Float 0;5;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-996.7034,418.9952;Inherit;False;Constant;_Float1;Float 1;5;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;20;-1137.871,537.5746;Inherit;False;Constant;_Float2;Float 2;5;0;Create;True;0;0;0;False;0;False;0.615984;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;8;-1472.382,41.07301;Inherit;True;Property;_DissloveTex;DissloveTex;2;0;Create;True;0;0;0;False;0;False;-1;aeca9810d485baf4490fc74b8d6c87ce;aeca9810d485baf4490fc74b8d6c87ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-757.5619,6.537921;Inherit;False;Property;_DissloveSlider;DissloveSlider;3;0;Create;True;0;0;0;False;0;False;0.3250297;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;2;421.4582,236.4857;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;94.8855,617.5884;Inherit;False;Property;_DepthDistance;DepthDistance;1;0;Create;True;0;0;0;False;0;False;0;0;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;3;682.7782,237.501;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;15;658.519,339.8075;Inherit;False;Property;_Color;Color ;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1116.517,-91.83585;Float;False;True;-1;2;ASEMaterialInspector;100;5;MyASEShader/SoftDisslove;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SaturateNode;21;-337.4882,329.4799;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;123.5407,208.2169;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;87.10759,-91.77166;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;23;436.6703,7.866346;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;-101.4371,-437.2754;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;11;160.2831,-437.7828;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ColorNode;24;-364.5956,-308.4731;Inherit;False;Property;_MainColor;MainColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;924.7112,-12.94269;Inherit;False;3;3;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.VertexColorNode;6;-1150.231,-510.9457;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;9;-243.3795,-67.72649;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1401.873,-249.8134;Inherit;True;Property;_MianTex;MianTex;0;0;Create;True;0;0;0;False;0;False;-1;1f5824d926d61b546bc67a1c6b0a3de3;1f5824d926d61b546bc67a1c6b0a3de3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;12;0;11;0
WireConnection;12;3;10;0
WireConnection;16;0;8;1
WireConnection;16;1;18;0
WireConnection;16;2;17;0
WireConnection;17;0;19;0
WireConnection;17;1;6;4
WireConnection;2;0;4;0
WireConnection;3;0;2;0
WireConnection;0;0;14;0
WireConnection;21;0;16;0
WireConnection;22;0;6;4
WireConnection;22;1;1;4
WireConnection;22;2;21;0
WireConnection;10;0;1;4
WireConnection;10;1;9;0
WireConnection;23;0;11;0
WireConnection;23;3;22;0
WireConnection;5;0;6;0
WireConnection;5;1;1;0
WireConnection;5;2;24;0
WireConnection;11;0;5;0
WireConnection;14;0;23;0
WireConnection;14;1;3;0
WireConnection;14;2;15;0
WireConnection;9;0;6;4
WireConnection;9;1;8;1
ASEEND*/
//CHKSM=C846C9E166BC59910727BDA8CC39EC4F75558292