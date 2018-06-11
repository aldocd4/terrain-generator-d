module tgd.GradientGenerator;

import tgd.Math;

class GradientGenerator
{
    public static float[][] radial(int x, int y, int radius) 
    {
        int width = radius * 2;
        int height = width;
        
        float[][] grad = new float[][](width, height);
        
        foreach(ref row; grad)
        {
            row[] = 0.0f;
        }

        for(int i = x; i < width; i++)
        {
            for(int j = y; j < height; j++)
            {
                int d = cast(int) sqrt( cast(float)( (i-radius) * (i-radius) + (j-radius) * (j-radius) ) );

                if(d < radius)
                {
                    auto distFromCenter = distance(i, j, radius, radius) / cast(float)radius;
                    auto alpha = 1.0f - distFromCenter;

                    grad[i][j] = 1.0f * alpha;
                }
            }
        }

        return grad;
    }
}