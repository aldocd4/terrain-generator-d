import std.math : pow;

import derelict.freeimage.freeimage;

import tgd.Bitmap;
import tgd.GradientGenerator;
import tgd.Noise;
import tgd.Math;

Color DEEP_WATER  = Color(51, 0, 0);
Color WATER       = Color(156, 2, 0);
Color CLEAR_WATER = Color(255, 156, 3);
Color BEACH       = Color(148, 255, 255);
Color FOREST      = Color(0, 115, 0);

Color biome(double value) 
{
    auto v = value * (256 - 1);

    return linearGradient[cast(uint)v][0];
}

class MyNoise : Noise
{
    public this(in int width, in int height)
    {
        super(width, height);
    }

    public override double[][] generate()
    {
        double[][] data = new double[][](this.m_width, this.m_height);
            
        immutable octaves = (0.40 + 0.10 + 0.05);
            
        for (int y = 0; y < this.m_height; y++) 
        {
            for (int x = 0; x < this.m_width; x++)
            {
                double nx = x / cast(double)this.m_width - 0.5;
                double ny = y / cast(double)this.m_height - 0.5;

                auto e = 
                    (0.40 * this.noise( 8 * nx,  8 * ny )
                    + 0.10 * this.noise( 32 * nx, 32 * ny )
                    + 0.05 * this.noise( 64 * nx, 64 * ny ));

                e /= octaves;

                data[x][y] = e;
            }
        }

        return data;
    } 
}

Color[][] linearGradient;

void main()
{
    DerelictFI.load();
    
    int width = 512;
    int height = 512;

    auto coloredBitmap = new Bitmap(width, height);

    auto circle = GradientGenerator.radial(0, 0, width / 2);    
    auto noise = (new MyNoise(width, height)).generate();
    linearGradient = GradientGenerator.linear(256, 60, 
        [
            LinearGradientRect(Rectangle(0, 0, 80, 60), [DEEP_WATER, WATER]),
            LinearGradientRect(Rectangle(80, 0, 20, 60), [WATER, CLEAR_WATER]),

            LinearGradientRect(Rectangle(100, 0, 40, 60), [CLEAR_WATER, BEACH]),
            LinearGradientRect(Rectangle(140, 0, 60, 60), [BEACH, FOREST]),

            LinearGradientRect(Rectangle(200, 0, 56, 60), [FOREST, FOREST]),
        ]
    );

    /** 
     * The weight applied to a vs b
     * 2.0 will double the contribution of a to the result
     * 0.5 will do the exact opposite
     */
    auto weight = 1.50;

    for (int y = 0; y < height; y++) 
    {
        for (int x = 0; x < width; x++)
        {
            auto a = circle[x][y];            
            auto b = noise[x][y];

            auto value = ((a * weight) + (b * 1.0 / weight)) / 2.0;

            // Water level, smaller value less water
            value = pow(value, 1.20);

            auto color = biome(value);
            coloredBitmap[x, y] = &color;
        }
    }

    coloredBitmap.save("island.png");
    coloredBitmap.dispose();

    /** Mandatory, just to check gradient result **/
    auto gradientBitmap = new Bitmap(256, 60);
    
    for (int x = 0; x < 256; x++)
    {
        for (int y = 0; y < 60; y++) 
        {
            gradientBitmap[x, y] = &linearGradient[x][y];
        }
    }

    gradientBitmap.save("gradient.png");
    gradientBitmap.dispose();

    DerelictFI.unload();
}