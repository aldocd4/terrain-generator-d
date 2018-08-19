module tgd.GradientGenerator;

import std.typecons;

import tgd.Math;
import tgd.Color;

alias LinearGradientRect = Tuple!(Rectangle, "rect", Color[2], "colors");

class GradientGenerator
{
    enum LinearGradientMode
    {
        Vertical,
        Horizontal
    }

    /**
     * Radial gradient
     */
    public static float[][] radial(in int x, in int y, in int radius) pure nothrow @safe
    {
        int width = radius * 2;
        int height = width;
        
        float[][] grad = new float[][](width, height);
        
        foreach (ref row; grad)
        {
            row[] = 0.0f;
        }

        for (int i = x; i < width; i++)
        {
            for (int j = y; j < height; j++)
            {
                int d = cast(int) sqrt( cast(float)( (i-radius) * (i-radius) + (j-radius) * (j-radius) ) );

                if (d < radius)
                {
                    auto distFromCenter = distance(i, j, radius, radius) / cast(float)radius;
                    auto alpha = 1.0f - distFromCenter;

                    grad[i][j] = 1.0f * alpha;
                }
            }
        }

        return grad;
    }

    /**
     * Linear gradient
     */
    public static Color[][] linear(LinearGradientMode gradientMode = LinearGradientMode.Horizontal)
        (in int width, in int height, in auto ref Color srcColor, in auto ref Color dstColor) pure nothrow @safe
    {
        return this.linear(width, height,
            [
                LinearGradientRect(Rectangle(0, 0, width, height), [srcColor, dstColor]),
            ]
        );
    }

    /**
     * Linear gradient
     */
    public static Color[][] linear(LinearGradientMode gradientMode = LinearGradientMode.Horizontal)
        (in int width, in int height, LinearGradientRect[] gradients) pure nothrow @safe
    {
        auto grad = new Color[][](width, height);

        foreach (i, gradient; gradients)
        {
            auto position = gradient.rect.position;
            auto size = gradient.rect.size;
            auto colors = gradient.colors;
            auto right = gradient.rect.right;
            auto top = gradient.rect.top;
            
            for (int x = position.x; x < right; x++)
            {
                for (int y = position.y; y < top; y++)
                {
                    float a = 0.0f;
                    
                    static if(gradientMode == LinearGradientMode.Horizontal)
                    {
                        a = (right - (x + 1)) / cast(float)size.width;
                    }
                    else a = (top - (y + 1)) / cast(float)size.height;
                    
                    grad[x][y] = lerp(colors[1], colors[0], a);
                }
            }
        }

        return grad;
    }
}