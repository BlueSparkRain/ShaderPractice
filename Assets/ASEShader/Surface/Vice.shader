// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vice"
{
	Properties
	{
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_VertexWidth("VertexWidth", Range( -10 , 10)) = 0
		_Float1("Float 1", Float) = 0.1
		_Clip("Clip", Range( 0 , 2)) = 0
		_SmMin("SmMin", Range( 0 , 1)) = 0
		_SmMax("SmMax", Range( 0 , 1.5)) = 0
		_AddNormalScale("AddNormalScale", Range( -2 , 2)) = 0
		_AlbedoTex("AlbedoTex", 2D) = "white" {}
		_NormalTex("NormalTex", 2D) = "bump" {}
		_MainTex("MainTex", 2D) = "white" {}
		[HDR]_MainColor2("MainColor2", Color) = (1,1,1,0)
		[HDR]_MainColor1("MainColor1", Color) = (0,0.5031446,0.2599747,0)
		[HDR]_MainLit("MainLit", Color) = (1,1,1,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Custom"  "Queue" = "AlphaTest+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float _VertexWidth;
		uniform float _Float1;
		uniform float _SmMin;
		uniform float _SmMax;
		uniform float _Clip;
		uniform float _AddNormalScale;
		uniform sampler2D _NormalTex;
		uniform float4 _NormalTex_ST;
		uniform sampler2D _AlbedoTex;
		uniform float4 _AlbedoTex_ST;
		uniform float4 _MainColor1;
		uniform float4 _MainColor2;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _MainLit;
		uniform float _Cutoff = 0.5;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_13_0 = ( _Clip - v.texcoord.xy.y );
			float smoothstepResult16 = smoothstep( _SmMin , _SmMax , temp_output_13_0);
			v.vertex.xyz += ( ( ase_vertexNormal * _VertexWidth * _Float1 * smoothstepResult16 ) + ( ase_vertexNormal * _AddNormalScale ) );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalTex = i.uv_texcoord * _NormalTex_ST.xy + _NormalTex_ST.zw;
			o.Normal = UnpackNormal( tex2D( _NormalTex, uv_NormalTex ) );
			float2 uv_AlbedoTex = i.uv_texcoord * _AlbedoTex_ST.xy + _AlbedoTex_ST.zw;
			o.Albedo = tex2D( _AlbedoTex, uv_AlbedoTex ).rgb;
			float temp_output_13_0 = ( _Clip - i.uv_texcoord.y );
			float temp_output_20_0 = ( 1.0 - temp_output_13_0 );
			float4 lerpResult30 = lerp( _MainColor1 , _MainColor2 , temp_output_20_0);
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Emission = ( lerpResult30 * tex2D( _MainTex, uv_MainTex ) * _MainLit ).rgb;
			o.Alpha = 1;
			clip( temp_output_20_0 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-631.7625,-42.04091;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-697.7625,113.9591;Inherit;False;Property;_VertexWidth;VertexWidth;1;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-731.1023,-416.6932;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-492.1992,-224.5292;Inherit;False;Property;_SmMin;SmMin;4;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-497.9609,-142.3775;Inherit;False;Property;_SmMax;SmMax;5;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-9.118988,12.64163;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-525.7625,195.9591;Inherit;False;Property;_Float1;Float 1;2;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;22;165.8386,145.3865;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;23;11.60909,234.2954;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-288.6844,311.41;Inherit;False;Property;_AddNormalScale;AddNormalScale;6;0;Create;True;0;0;0;False;0;False;0;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;-82.66289,-315.3329;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;25;-93.62991,-764.5649;Inherit;True;Property;_AlbedoTex;AlbedoTex;7;0;Create;True;0;0;0;False;0;False;-1;812d4dd5fe95b6c4a9610d75f22c7f7b;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;26;-143.5277,-592.1918;Inherit;True;Property;_NormalTex;NormalTex;8;0;Create;True;0;0;0;False;0;False;-1;016e2eb666d88f046ba69fc74e57b6e3;None;True;0;False;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;29;81.46556,-615.7797;Inherit;False;Property;_MainColor2;MainColor2;10;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;30;486.7495,-708.3167;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;31;105.7126,-809.0195;Inherit;False;Property;_MainColor1;MainColor1;11;1;[HDR];Create;True;0;0;0;False;0;False;0,0.5031446,0.2599747,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-380.3586,-383.0899;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-188.1115,-169.4579;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;27;-449.6382,-633.0558;Inherit;True;Property;_MainTex;MainTex;9;0;Create;True;0;0;0;False;0;False;-1;dc824d4065c2c8c4c9cab86675d44c0c;dc824d4065c2c8c4c9cab86675d44c0c;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-740.5537,-294.3968;Inherit;False;Property;_Clip;Clip;3;0;Create;True;0;0;0;False;0;False;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;21;835.4509,-432.2192;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Vice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Custom;0.5;True;True;0;False;Custom;;AlphaTest;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;0;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;472.0703,-436.6826;Inherit;False;3;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;32;212.5563,-356.5213;Inherit;False;Property;_MainLit;MainLit;12;1;[HDR];Create;True;0;0;0;False;0;False;1,1,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
WireConnection;14;0;10;0
WireConnection;14;1;12;0
WireConnection;14;2;11;0
WireConnection;14;3;16;0
WireConnection;22;0;14;0
WireConnection;22;1;23;0
WireConnection;23;0;10;0
WireConnection;23;1;24;0
WireConnection;20;0;13;0
WireConnection;30;0;31;0
WireConnection;30;1;29;0
WireConnection;30;2;20;0
WireConnection;13;0;19;0
WireConnection;13;1;15;2
WireConnection;16;0;13;0
WireConnection;16;1;17;0
WireConnection;16;2;18;0
WireConnection;21;0;25;0
WireConnection;21;1;26;0
WireConnection;21;2;28;0
WireConnection;21;10;20;0
WireConnection;21;11;22;0
WireConnection;28;0;30;0
WireConnection;28;1;27;0
WireConnection;28;2;32;0
ASEEND*/
//CHKSM=5476DA8E4469F27A6319C9D0767B58AD9E3D6C30