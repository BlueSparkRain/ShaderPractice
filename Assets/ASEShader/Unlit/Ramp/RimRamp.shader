// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyASEShader/RimRamp"
{
	Properties
	{
		_DissloveTex("DissloveTex", 2D) = "white" {}
		_RampTex("RampTex", 2D) = "white" {}
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_MainColor("MainColor", Color) = (1,1,1,0)
		[HDR]_RampColor("RampColor", Color) = (1,1,1,0)
		_RimWidth("RimWidth", Range( 0 , 1)) = 0.6012568
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
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform float4 _RampColor;
			uniform sampler2D _RampTex;
			uniform float _RimWidth;
			uniform sampler2D _DissloveTex;
			uniform float4 _DissloveTex_ST;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float4 _MainColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

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
				float2 uv_DissloveTex = i.ase_texcoord1.xy * _DissloveTex_ST.xy + _DissloveTex_ST.zw;
				float smoothstepResult39 = smoothstep( 0.0 , _RimWidth , ( tex2D( _DissloveTex, uv_DissloveTex ).r + 1.0 + ( -2.0 * saturate( _SinTime.w ) ) ));
				float2 appendResult8 = (float2(smoothstepResult39 , 0.0));
				float4 tex2DNode7 = tex2D( _RampTex, appendResult8 );
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode25 = tex2D( _MainTex, uv_MainTex );
				float4 lerpResult28 = lerp( ( _RampColor * tex2DNode7 ) , ( tex2DNode25 * _MainColor ) , tex2DNode7.b);
				float4 appendResult32 = (float4((lerpResult28).rgb , ( saturate( smoothstepResult39 ) * tex2DNode25.a * _MainColor.a )));
				
				
				finalColor = appendResult32;
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
Node;AmplifyShaderEditor.SamplerNode;7;-30.64673,-177.6459;Inherit;True;Property;_RampTex;RampTex;1;0;Create;True;0;0;0;False;0;False;-1;5f6ec54a821902545a03eb0261d83602;5f6ec54a821902545a03eb0261d83602;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-1215.053,-328.6325;Inherit;True;Property;_DissloveTex;DissloveTex;0;0;Create;True;0;0;0;False;0;False;-1;aeca9810d485baf4490fc74b8d6c87ce;aeca9810d485baf4490fc74b8d6c87ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;3;-1051.682,-129.5085;Inherit;False;Constant;_Float0;Float 0;1;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-899.6362,-49.11117;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-400.9983,185.9049;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;1f5824d926d61b546bc67a1c6b0a3de3;1f5824d926d61b546bc67a1c6b0a3de3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;1047.564,448.7411;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-1221.014,60.12627;Inherit;False;Property;_Float2;Float 2;2;0;Create;True;0;0;0;False;0;False;0.6545333;0.5385064;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1138.995,-25.88815;Inherit;False;Constant;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;-2;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;-780.7618,-298.0286;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;39;-412.42,-296.8322;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-186.1464,-297.9438;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-719.5407,-45.44762;Inherit;False;Property;_RimWidth;RimWidth;6;0;Create;True;0;0;0;False;0;False;0.6012568;0.6012568;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SinTimeNode;43;-1295.897,143.905;Inherit;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;44;-1075.974,166.2803;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;35;-248.6423,70.72144;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;27;-312.8705,396.3699;Inherit;False;Property;_MainColor;MainColor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;219.4805,95.67677;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;384.5016,-195.9729;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;28;765.4886,71.43494;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;30;59.7906,-367.6382;Inherit;False;Property;_RampColor;RampColor;5;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;31;1044.346,66.65288;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;32;1321.093,208.3099;Inherit;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1709.439,204.5026;Float;False;True;-1;2;ASEMaterialInspector;100;5;MyASEShader/RimRamp;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;7;1;8;0
WireConnection;4;0;5;0
WireConnection;4;1;44;0
WireConnection;33;0;35;0
WireConnection;33;1;25;4
WireConnection;33;2;27;4
WireConnection;2;0;1;1
WireConnection;2;1;3;0
WireConnection;2;2;4;0
WireConnection;39;0;2;0
WireConnection;39;2;40;0
WireConnection;8;0;39;0
WireConnection;44;0;43;4
WireConnection;35;0;39;0
WireConnection;26;0;25;0
WireConnection;26;1;27;0
WireConnection;29;0;30;0
WireConnection;29;1;7;0
WireConnection;28;0;29;0
WireConnection;28;1;26;0
WireConnection;28;2;7;3
WireConnection;31;0;28;0
WireConnection;32;0;31;0
WireConnection;32;3;33;0
WireConnection;0;0;32;0
ASEEND*/
//CHKSM=DEAE9C51A735263774D2B1F30C5CFAD0245BDD86