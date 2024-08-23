// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "RGBOffset"
{
	Properties
	{
		_MianTex("MianTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_NoiseSpeed("NoiseSpeed", Vector) = (0.5,-0.5,0,0)
		_RG_Offset("RG_Offset", Vector) = (0.03,0,-0.03,0)
		_NoiseIntensity("NoiseIntensity", Range( 0 , 0.5)) = 0.1491136
		_TimeScale("TimeScale", Range( 1 , 6)) = 1

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

			uniform sampler2D _MianTex;
			uniform sampler2D _NoiseTex;
			uniform float2 _NoiseSpeed;
			uniform float4 _NoiseTex_ST;
			uniform float _NoiseIntensity;
			uniform float _TimeScale;
			uniform float4 _RG_Offset;

			
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
				float2 texCoord15 = i.ase_texcoord1.xy * float2( 1,1 ) + float2( 0,0 );
				float2 uv_NoiseTex = i.ase_texcoord1.xy * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
				float2 panner6 = ( 1.0 * _Time.y * _NoiseSpeed + uv_NoiseTex);
				float mulTime34 = _Time.y * _TimeScale;
				float temp_output_31_0 = saturate( ( _NoiseIntensity * sin( mulTime34 ) ) );
				float2 appendResult17 = (float2(( texCoord15.x + ( (-0.5 + (tex2D( _NoiseTex, panner6 ).r - 0.0) * (0.5 - -0.5) / (1.0 - 0.0)) * temp_output_31_0 ) ) , texCoord15.y));
				float temp_output_32_0 = (0.0 + (temp_output_31_0 - 0.0) * (1.0 - 0.0) / (1.0 - 0.0));
				float2 appendResult10 = (float2(_RG_Offset.x , _RG_Offset.y));
				float4 tex2DNode4 = tex2D( _MianTex, appendResult17 );
				float2 appendResult11 = (float2(_RG_Offset.z , _RG_Offset.w));
				float4 appendResult23 = (float4(tex2D( _MianTex, ( appendResult17 + ( temp_output_32_0 * appendResult10 ) ) ).r , tex2DNode4.g , tex2D( _MianTex, ( appendResult17 + ( temp_output_32_0 * appendResult11 ) ) ).b , tex2DNode4.a));
				
				
				finalColor = appendResult23;
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
Node;AmplifyShaderEditor.Vector4Node;13;-1861.627,823.7033;Inherit;False;Property;_RG_Offset;RG_Offset;3;0;Create;True;0;0;0;False;0;False;0.03,0,-0.03,0;0,0,0,0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SinOpNode;33;-2277.305,873.3291;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-1607.43,74.06367;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-1943.006,135.4592;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1413.728,149.083;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;8;-2297.159,189.5434;Inherit;True;Property;_NoiseTex;NoiseTex;1;0;Create;True;0;0;0;False;0;False;-1;62a9fe8f0a3cfcb43a31e600bbd39379;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCRemapNode;36;-1981.02,307.4202;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-0.5;False;4;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-1786.238,368.2894;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;31;-1949.292,515.2101;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-2403.188,678.7418;Inherit;False;Property;_NoiseIntensity;NoiseIntensity;4;0;Create;True;0;0;0;False;0;False;0.1491136;0;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-2127.222,757.6823;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;34;-2462.615,872.6507;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-2792.395,866.1956;Inherit;False;Property;_TimeScale;TimeScale;5;0;Create;True;0;0;0;False;0;False;1;0;1;6;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;6;-2493.539,354.5926;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;7;-2744.087,287.4147;Inherit;False;0;8;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;9;-2704.408,445.9032;Inherit;False;Property;_NoiseSpeed;NoiseSpeed;2;0;Create;True;0;0;0;False;0;False;0.5,-0.5;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;21;-1057.676,147.391;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;32;-1758.883,596.5729;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;10;-1625.606,785.3826;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;11;-1622.462,951.7893;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;26;-1379.395,925.8606;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;-1042.557,905.9025;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;5;-719.7086,876.2861;Inherit;True;Property;_TextureSample2;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;4;-721.7892,465.1697;Inherit;True;Property;_TextureSample1;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-737.2728,117.7351;Inherit;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1386.11,599.9886;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexturePropertyNode;3;-1216.244,-88.50111;Inherit;True;Property;_MianTex;MianTex;0;0;Create;True;0;0;0;False;0;False;ea946fd8b60508249a559b2c7f635227;None;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.DynamicAppendNode;23;-287.5705,490.8335;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;-30.33277,491.2749;Float;False;True;-1;2;ASEMaterialInspector;100;5;RGBOffset;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;False;True;0;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;True;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
WireConnection;33;0;34;0
WireConnection;16;0;15;1
WireConnection;16;1;18;0
WireConnection;17;0;16;0
WireConnection;17;1;15;2
WireConnection;8;1;6;0
WireConnection;36;0;8;1
WireConnection;18;0;36;0
WireConnection;18;1;31;0
WireConnection;31;0;30;0
WireConnection;30;0;19;0
WireConnection;30;1;33;0
WireConnection;34;0;35;0
WireConnection;6;0;7;0
WireConnection;6;2;9;0
WireConnection;21;0;17;0
WireConnection;21;1;25;0
WireConnection;32;0;31;0
WireConnection;10;0;13;1
WireConnection;10;1;13;2
WireConnection;11;0;13;3
WireConnection;11;1;13;4
WireConnection;26;0;32;0
WireConnection;26;1;11;0
WireConnection;22;0;17;0
WireConnection;22;1;26;0
WireConnection;5;0;3;0
WireConnection;5;1;22;0
WireConnection;4;0;3;0
WireConnection;4;1;17;0
WireConnection;1;0;3;0
WireConnection;1;1;21;0
WireConnection;25;0;32;0
WireConnection;25;1;10;0
WireConnection;23;0;1;1
WireConnection;23;1;4;2
WireConnection;23;2;5;3
WireConnection;23;3;4;4
WireConnection;0;0;23;0
ASEEND*/
//CHKSM=902689E3BED37FB119EA6DF43C27C081DB47F02E