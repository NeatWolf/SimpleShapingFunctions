﻿// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ImageEffects/SmoothStepShape"
{
    Properties
    {
        
    }
    SubShader
    {
        Pass{
            Cull off
            ZTest Always
            ZWrite Off

            CGPROGRAM
            
            #include "UnityCG.cginc"
            // Use shader model 3.0 target, to get nicer looking lighting
            #pragma target 3.0

            #pragma vertex VertexProgram
            #pragma fragment FragmentProgram
            
            #include "ImageEffectVertex.cginc"

            float plot(float2 xy, float y){
                return smoothstep( y-0.02, y, xy.y) - smoothstep( y, y+0.02, xy.y);
            }

            float applySmoothStepTransform(float2 xy, float from, float to){
                return smoothstep(from, to, xy.x);;
            }

            float4 FragmentProgram(Interpolators i) : SV_Target{
                //Simpler form
                // float y = applySmoothStepTransform(i.screenPos, 0.001, 0.99);

                //compound transform
                float y = applySmoothStepTransform(i.screenPos, 0.2, 0.5) - applySmoothStepTransform(i.screenPos, 0.5, 0.8);

                float3 color = y;

                float pct = plot(i.screenPos, y);

                color = (1-pct)*color + pct * float3(0,1,0);
                // color = pct;
                return float4(color, 1);
            }
            ENDCG
        }
    }
    
}
