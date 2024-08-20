// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Mask"
{
	Properties
	{
		_TextureSample0("MainTex", 2D) = "white" {}
		_Vector0("MainTexSpeed", Vector) = (0.3,0,0,0)
		_Vector1("MaskTexSpeed", Vector) = (0.5,0,0,0)
		_TextureSample1("Mask", 2D) = "white" {}
		_DissloveSlider("DissloveSlider", Range( 0 , 1)) = 0.2389849
		_RimWidth("RimWidth", Range( 0 , 0.5)) = 0.1022051
		[HDR]_MainColor("MainColor", Color) = (1,0,0,0)

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

			uniform sampler2D _TextureSample0;
			uniform float2 _Vector0;
			uniform float4 _TextureSample0_ST;
			uniform float4 _MainColor;
			uniform float _DissloveSlider;
			uniform sampler2D _TextureSample1;
			uniform float2 _Vector1;
			uniform float4 _TextureSample1_ST;
			uniform float _RimWidth;

			
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
				float2 uv_TextureSample0 = i.ase_texcoord1.xy * _TextureSample0_ST.xy + _TextureSample0_ST.zw;
				float2 panner3 = ( 1.0 * _Time.y * _Vector0 + uv_TextureSample0);
				float4 tex2DNode1 = tex2D( _TextureSample0, panner3 );
				float2 uv_TextureSample1 = i.ase_texcoord1.xy * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
				float2 panner9 = ( 1.0 * _Time.y * _Vector1 + uv_TextureSample1);
				float4 tex2DNode7 = tex2D( _TextureSample1, panner9 );
				float temp_output_19_0 = step( _DissloveSlider , ( tex2DNode7.r + _RimWidth ) );
				float4 appendResult26 = (float4((( tex2DNode1 * _MainColor )).rgba.rgb , ( tex2DNode1.a * temp_output_19_0 )));
				
				
				finalColor = appendResult26;
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
Node;AmplifyShaderEditor.CommentaryNode;32;-1083.577,170.6941;Inherit;False;2125.642;895.0094;光边;11;22;23;15;16;19;20;17;18;7;21;24;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;4;-1307.504,-68.89525;Inherit;False;Property;_Vector0;MainTexSpeed;1;0;Create;False;0;0;0;False;0;False;0.3,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;2;-1279.363,-219.2749;Inherit;False;0;1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-807.1061,-172.9148;Inherit;True;Property;_TextureSample0;MainTex;0;0;Create;False;0;0;0;False;0;False;-1;87245f5aaf411b244a77dfc67ef3db74;87245f5aaf411b244a77dfc67ef3db74;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;3;-1018.178,-145.8058;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ColorNode;30;248.7775,-163.9201;Inherit;False;Property;_MainColor;MainColor;7;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;543.4539,-203.5611;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;8;-1541.026,295.8758;Inherit;False;0;7;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;9;-1269.829,320.1322;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;10;-1506.257,429.1916;Inherit;False;Property;_Vector1;MaskTexSpeed;2;0;Create;False;0;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;519.4459,684.4303;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;23;123.7474,858.7036;Inherit;False;Property;_RimColor;RimColor;6;1;[HDR];Create;True;0;0;0;False;0;False;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;15;-307.0662,289.6273;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;-648.538,373.3166;Inherit;False;Property;_DissloveSlider;DissloveSlider;4;0;Create;True;0;0;0;False;0;False;0.2389849;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;19;-289.5275,563.4664;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;20;43.28528,275.7093;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-669.341,500.4105;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-971.9666,636.6935;Inherit;False;Property;_RimWidth;RimWidth;5;0;Create;True;0;0;0;False;0;False;0.1022051;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;7;-1033.577,290.0271;Inherit;True;Property;_TextureSample1;Mask;3;0;Create;False;0;0;0;False;0;False;-1;aeca9810d485baf4490fc74b8d6c87ce;aeca9810d485baf4490fc74b8d6c87ce;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;21;611.0671,226.1479;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;24;817.3989,220.6941;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;31;784.0721,-212.2603;Inherit;False;True;True;True;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;26;1229.647,27.32069;Inherit;True;FLOAT4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;1077.368,528.8776;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;1561.507,28.03484;Float;False;True;-1;2;ASEMaterialInspector;100;5;Mask;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;1;1;3;0
WireConnection;3;0;2;0
WireConnection;3;2;4;0
WireConnection;29;0;1;0
WireConnection;29;1;30;0
WireConnection;9;0;8;0
WireConnection;9;2;10;0
WireConnection;22;0;1;4
WireConnection;22;1;20;0
WireConnection;22;2;23;0
WireConnection;15;0;16;0
WireConnection;15;1;7;1
WireConnection;19;0;16;0
WireConnection;19;1;17;0
WireConnection;20;0;19;0
WireConnection;20;1;15;0
WireConnection;17;0;7;1
WireConnection;17;1;18;0
WireConnection;7;1;9;0
WireConnection;21;0;1;0
WireConnection;21;1;22;0
WireConnection;21;2;20;0
WireConnection;24;0;21;0
WireConnection;31;0;29;0
WireConnection;26;0;31;0
WireConnection;26;3;25;0
WireConnection;25;0;1;4
WireConnection;25;1;19;0
WireConnection;0;0;26;0
ASEEND*/
//CHKSM=1C291D4662EE984BFA5338061DC60036330DEEEE