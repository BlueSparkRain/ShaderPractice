// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "VertexOffset"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_MianColor("MianColor", Color) = (1,1,1,0)
		[HDR]_SubColor("SubColor", Color) = (0.06688814,0.1103723,0.2389936,0)
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0.5,0,0,0)
		_MaskSpeed("MaskSpeed", Vector) = (0,0.6,0,0)
		_Height("Height", Float) = -0.8
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
		ZWrite On
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
			#define ASE_NEEDS_VERT_COLOR


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
				float4 ase_color : COLOR;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			uniform sampler2D _NoiseTex;
			uniform float2 _NoiseSpeed;
			uniform float4 _NoiseTex_ST;
			uniform sampler2D _MaskTex;
			uniform float2 _MaskSpeed;
			uniform float4 _MaskTex_ST;
			uniform float _Height;
			uniform float4 _SubColor;
			uniform float4 _MianColor;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv_NoiseTex = v.ase_texcoord.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float2 panner11 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseTex);
				float2 uv_MaskTex = v.ase_texcoord.xy * _MaskTex_ST.xy + _MaskTex_ST.zw;
				float2 panner14 = ( 1.0 * _Time.y * _MaskSpeed + uv_MaskTex);
				float4 appendResult8 = (float4(0.0 , 0.0 , ( v.color.a * ( ( tex2Dlod( _NoiseTex, float4( panner11, 0, 0.0) ).r * tex2Dlod( _MaskTex, float4( panner14, 0, 0.0) ).r ) + _Height ) ) , 0.0));
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				o.ase_color = v.color;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = appendResult8.xyz;
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
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode1 = tex2D( _MainTex, uv_MainTex );
				float4 lerpResult2 = lerp( _SubColor , ( _MianColor * tex2DNode1 ) , tex2DNode1.r);
				float4 appendResult6 = (float4(lerpResult2.rgb , i.ase_color.b));
				
				
				finalColor = appendResult6;
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
Node;AmplifyShaderEditor.SamplerNode;1;-804.3037,-178.6782;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;False;0;False;-1;f3c99c3f2b99d01418caa1abbc6778e2;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-229.8694,-138.9453;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;3;-482.4292,-301.1613;Inherit;False;Property;_MianColor;MianColor;1;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;6;276.484,67.93301;Inherit;False;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.PannerNode;11;-1014.473,410.3968;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1266.072,686.0441;Inherit;False;0;10;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;12;-1295.504,355.4826;Inherit;False;0;9;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;13;-1261.048,510.5343;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;5;0;Create;True;0;0;0;False;0;False;0.5,0;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;16;-1231.616,841.0958;Inherit;False;Property;_MaskSpeed;MaskSpeed;6;0;Create;True;0;0;0;False;0;False;0,0.6;0.5,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;18;-10.94557,554.6811;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-713.2355,694.4315;Inherit;True;Property;_MaskTex;MaskTex;4;0;Create;True;0;0;0;False;0;False;-1;d50d4704bacac2344a7c57f9bb00661a;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;14;-983.7644,705.2094;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;292.916,393.7809;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-248.953,711.3163;Inherit;False;Property;_Height;Height;7;0;Create;True;0;0;0;False;0;False;-0.8;-0.8;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-728.8864,348.8047;Inherit;True;Property;_NoiseTex;NoiseTex;3;0;Create;True;0;0;0;False;0;False;-1;cb3a0d716d0a59246908c343e51c1ddd;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;590.5197,7.474043;Float;False;True;-1;2;ASEMaterialInspector;100;5;VertexOffset;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.ColorNode;5;-700.9069,92.44851;Inherit;False;Property;_SubColor;SubColor;2;1;[HDR];Create;True;0;0;0;False;0;False;0.06688814,0.1103723,0.2389936,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;2;-93.11723,-31.18567;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;7;-108.6466,226.234;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-301.9926,383.8408;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;559.1582,389.7702;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;22;412.7889,394.7167;Inherit;False;Constant;_Float1;Float 1;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;342.0204,258.3575;Inherit;False;Constant;_Float0;Float 0;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
WireConnection;4;0;3;0
WireConnection;4;1;1;0
WireConnection;6;0;2;0
WireConnection;6;3;7;3
WireConnection;11;0;12;0
WireConnection;11;2;13;0
WireConnection;18;0;17;0
WireConnection;18;1;19;0
WireConnection;10;1;14;0
WireConnection;14;0;15;0
WireConnection;14;2;16;0
WireConnection;20;0;7;4
WireConnection;20;1;18;0
WireConnection;9;1;11;0
WireConnection;0;0;6;0
WireConnection;0;1;8;0
WireConnection;2;0;5;0
WireConnection;2;1;4;0
WireConnection;2;2;1;1
WireConnection;17;0;9;1
WireConnection;17;1;10;1
WireConnection;8;0;21;0
WireConnection;8;1;22;0
WireConnection;8;2;20;0
ASEEND*/
//CHKSM=CF61A63B745BB8ED665915D3BEBE267DB8590D5A