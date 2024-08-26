// Made with Amplify Shader Editor v1.9.1.5
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Vice"
{
	Properties
	{
		_VertexWidth("VertexWidth", Range( -10 , 10)) = 0
		_Float1("Float 1", Float) = 0.1
		_Clip("Clip", Range( -2 , 2)) = 0
		_SmMin("SmMin", Range( 0 , 1)) = 0
		_SmMax("SmMax", Range( 0 , 1.5)) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
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

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float temp_output_13_0 = ( _Clip - v.texcoord.xy.y );
			float smoothstepResult16 = smoothstep( _SmMin , _SmMax , temp_output_13_0);
			v.vertex.xyz += ( ase_vertexNormal * _VertexWidth * _Float1 * smoothstepResult16 );
			v.vertex.w = 1;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float temp_output_13_0 = ( _Clip - i.uv_texcoord.y );
			float smoothstepResult16 = smoothstep( _SmMin , _SmMax , temp_output_13_0);
			float3 temp_cast_0 = (smoothstepResult16).xxx;
			o.Emission = temp_cast_0;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=19105
Node;AmplifyShaderEditor.NormalVertexDataNode;10;-631.7625,-42.04091;Inherit;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;12;-697.7625,113.9591;Inherit;False;Property;_VertexWidth;VertexWidth;0;0;Create;True;0;0;0;False;0;False;0;0;-10;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;13;-350.5459,-366.8284;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;15;-731.1023,-416.6932;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;19;-740.5537,-294.3968;Inherit;False;Property;_Clip;Clip;2;0;Create;True;0;0;0;False;0;False;0;0;-2;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-492.1992,-224.5292;Inherit;False;Property;_SmMin;SmMin;3;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-497.9609,-142.3775;Inherit;False;Property;_SmMax;SmMax;4;0;Create;True;0;0;0;False;0;False;0;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;16;-174.5602,-243.99;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;20;-36.3941,-367.0451;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;14;-9.118988,12.64163;Inherit;False;4;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-525.7625,195.9591;Inherit;False;Property;_Float1;Float 1;1;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;21;333.3333,-185.3333;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Vice;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;;0;False;;False;0;False;;0;False;;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;12;all;True;True;True;True;0;False;;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;2;15;10;25;False;0.5;True;0;0;False;;0;False;;0;0;False;;0;False;;0;False;;0;False;;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;;-1;0;False;;0;0;0;False;0.1;False;;0;False;;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;19;0
WireConnection;13;1;15;2
WireConnection;16;0;13;0
WireConnection;16;1;17;0
WireConnection;16;2;18;0
WireConnection;20;0;13;0
WireConnection;14;0;10;0
WireConnection;14;1;12;0
WireConnection;14;2;11;0
WireConnection;14;3;16;0
WireConnection;21;2;16;0
WireConnection;21;11;14;0
ASEEND*/
//CHKSM=4017E48190AC4D7BBE375BC3EDF4CA9C07A6603B