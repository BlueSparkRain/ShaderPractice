// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "MyASEShader/TwoSides "
{
	Properties
	{
		_FresnelHardness("FresnelHardness", Range( 0 , 1)) = 0
		_FresnelScale("FresnelScale", Range( 0 , 3)) = 1.146181
		_FresnelPower("FresnelPower", Range( 0 , 2)) = 1.71241
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_MainColor("MainColor", Color) = (1,0.7830188,0.7830188,0)
		_ScreenTilling("ScreenTilling", Vector) = (12,6,0,0)
		_BackTex("BackTex", 2D) = "white" {}
		_BackTexSpeed("BackTexSpeed", Vector) = (0.5,0,0,0)
		_AddTexSpeed("AddTexSpeed", Vector) = (0.3,0,0,0)
		_NoiseTexSpeed("NoiseTexSpeed", Vector) = (0.5,0,0,0)
		_AddTex("AddTex", 2D) = "white" {}
		_NoiseTex("NoiseTex", 2D) = "white" {}
		_BackNoiseIntensity("BackNoiseIntensity", Range( 0 , 1)) = 0.2225602
		[HDR]_BackColor("BackColor", Color) = (1,0.361635,0.361635,0)
		_AddTexTilling("AddTexTilling", Vector) = (1,1,0,0)
		_NoiseTexTilling("NoiseTexTilling", Vector) = (1,1,0,0)
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

			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform float _FresnelHardness;
			uniform float _FresnelScale;
			uniform float _FresnelPower;
			uniform float4 _MainColor;
			uniform sampler2D _BackTex;
			uniform float2 _BackTexSpeed;
			uniform float2 _ScreenTilling;
			uniform sampler2D _AddTex;
			uniform float2 _AddTexSpeed;
			uniform float2 _AddTexTilling;
			uniform sampler2D _NoiseTex;
			uniform float2 _NoiseTexSpeed;
			uniform float2 _NoiseTexTilling;
			uniform float _BackNoiseIntensity;
			uniform float4 _BackColor;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				float3 ase_worldNormal = UnityObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord3 = screenPos;
				
				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				o.ase_texcoord2.w = 0;
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
			
			fixed4 frag (v2f i , bool ase_vface : SV_IsFrontFace) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_MainTex = i.ase_texcoord1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float3 ase_worldViewDir = UnityWorldSpaceViewDir(WorldPosition);
				ase_worldViewDir = normalize(ase_worldViewDir);
				float3 ase_worldNormal = i.ase_texcoord2.xyz;
				float fresnelNdotV1 = dot( ase_worldNormal, ase_worldViewDir );
				float fresnelNode1 = ( _FresnelHardness + _FresnelScale * pow( 1.0 - fresnelNdotV1, _FresnelPower ) );
				float4 screenPos = i.ase_texcoord3;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float2 temp_output_24_0 = (ase_screenPosNorm).xy;
				float2 panner28 = ( 1.0 * _Time.y * _BackTexSpeed + ( temp_output_24_0 * _ScreenTilling ));
				float2 panner31 = ( 1.0 * _Time.y * _AddTexSpeed + ( temp_output_24_0 * _AddTexTilling ));
				float2 panner35 = ( 1.0 * _Time.y * _NoiseTexSpeed + ( temp_output_24_0 * _NoiseTexTilling ));
				float2 temp_cast_0 = (tex2D( _NoiseTex, panner35 ).r).xx;
				float2 lerpResult40 = lerp( panner31 , temp_cast_0 , _BackNoiseIntensity);
				float4 switchResult9 = (((ase_vface>0)?(( tex2D( _MainTex, uv_MainTex ) + ( saturate( fresnelNode1 ) * _MainColor ) )):(( tex2D( _BackTex, panner28 ) + ( tex2D( _AddTex, lerpResult40 ) * _BackColor ) ))));
				
				
				finalColor = switchResult9;
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
Node;AmplifyShaderEditor.FresnelNode;1;-523.5319,-112.9455;Inherit;True;Standard;WorldNormal;ViewDir;False;False;5;0;FLOAT3;0,0,1;False;4;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-396.057,-401.3113;Inherit;True;Property;_MainTex;MainTex;3;0;Create;True;0;0;0;False;0;False;-1;1c43d7e656dc34c459af5f333e57d670;1c43d7e656dc34c459af5f333e57d670;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;5;-855.6017,-71.54681;Inherit;False;Property;_FresnelScale;FresnelScale;1;0;Create;True;0;0;0;False;0;False;1.146181;1.146181;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;6;-882.0259,32.39016;Inherit;False;Property;_FresnelPower;FresnelPower;2;0;Create;True;0;0;0;False;0;False;1.71241;1.983889;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;10;-386.81,125.7157;Inherit;False;Property;_MainColor;MainColor;4;1;[HDR];Create;True;0;0;0;False;0;False;1,0.7830188,0.7830188,0;1,0.7830188,0.7830188,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;7;-131.1391,48.51086;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;2;84.66598,-232.571;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;8;-213.4024,-117.2522;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-861.7671,-170.1989;Inherit;False;Property;_FresnelHardness;FresnelHardness;0;0;Create;True;0;0;0;False;0;False;0;0.06264918;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;26;-502.452,591.54;Inherit;False;Property;_ScreenTilling;ScreenTilling;5;0;Create;True;0;0;0;False;0;False;12,6;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;28;-166.2321,658.0371;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;29;-465.4686,715.119;Inherit;False;Property;_BackTexSpeed;BackTexSpeed;7;0;Create;True;0;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-323.2112,480.3429;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;36;-927.6558,1473.12;Inherit;False;Property;_NoiseTexSpeed;NoiseTexSpeed;9;0;Create;True;0;0;0;False;0;False;0.5,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;35;-557.9769,1321.584;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;40;62.80719,1185.226;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;39;-355.6714,1292.302;Inherit;True;Property;_NoiseTex;NoiseTex;11;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;41;-332.9423,1494.7;Inherit;False;Property;_BackNoiseIntensity;BackNoiseIntensity;12;0;Create;True;0;0;0;False;0;False;0.2225602;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;38;275.2787,1130.171;Inherit;True;Property;_AddTex;AddTex;10;0;Create;True;0;0;0;False;0;False;-1;351070468ddb3244395356271f1e40b4;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;43;308.2556,1401.262;Inherit;False;Property;_BackColor;BackColor;13;1;[HDR];Create;True;0;0;0;False;0;False;1,0.361635,0.361635,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;868.882,1096.023;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;44;1180.166,757.3295;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;22;1120.209,-112.2169;Float;False;True;-1;2;ASEMaterialInspector;100;5;MyASEShader/TwoSides ;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;True;2;5;False;;10;False;;0;1;False;;0;False;;True;0;False;;0;False;;False;False;False;False;False;False;False;False;False;True;0;False;;True;True;2;False;;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;1;False;;True;3;False;;True;True;0;False;;0;False;;True;2;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;False;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;0;1;True;False;;False;0
Node;AmplifyShaderEditor.SwitchByFaceNode;9;673.4947,-41.00297;Inherit;False;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;32;-861.0293,1084.778;Inherit;False;Property;_AddTexSpeed;AddTexSpeed;8;0;Create;True;0;0;0;False;0;False;0.3,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScreenPosInputsNode;23;-1080.649,476.9254;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;24;-844.801,492.761;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;31;-400.0785,1044.909;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-460.637,906.749;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;46;-711.9674,933.7846;Inherit;False;Property;_AddTexTilling;AddTexTilling;14;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;48;-1106.072,1330.326;Inherit;False;Property;_NoiseTexTilling;NoiseTexTilling;15;0;Create;True;0;0;0;False;0;False;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-706.6882,1262.576;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;27;207.4576,718.0818;Inherit;True;Property;_BackTex;BackTex;6;0;Create;True;0;0;0;False;0;False;-1;6ef27d116e2553f4e88fe17ffbd95bec;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;1;1;4;0
WireConnection;1;2;5;0
WireConnection;1;3;6;0
WireConnection;7;0;8;0
WireConnection;7;1;10;0
WireConnection;2;0;3;0
WireConnection;2;1;7;0
WireConnection;8;0;1;0
WireConnection;28;0;25;0
WireConnection;28;2;29;0
WireConnection;25;0;24;0
WireConnection;25;1;26;0
WireConnection;35;0;47;0
WireConnection;35;2;36;0
WireConnection;40;0;31;0
WireConnection;40;1;39;1
WireConnection;40;2;41;0
WireConnection;39;1;35;0
WireConnection;38;1;40;0
WireConnection;42;0;38;0
WireConnection;42;1;43;0
WireConnection;44;0;27;0
WireConnection;44;1;42;0
WireConnection;22;0;9;0
WireConnection;9;0;2;0
WireConnection;9;1;44;0
WireConnection;24;0;23;0
WireConnection;31;0;45;0
WireConnection;31;2;32;0
WireConnection;45;0;24;0
WireConnection;45;1;46;0
WireConnection;47;0;24;0
WireConnection;47;1;48;0
WireConnection;27;1;28;0
ASEEND*/
//CHKSM=C6B6536C00C7CEE70F4950E55D4850B319C5C3D4