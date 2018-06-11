import std.math : pow;

import derelict.freeimage.freeimage;

import tgd.Bitmap;
import tgd.GradientGenerator;
import tgd.Noise;

Color DEEP_WATER = Color(173, 86, 56);
Color WATER      = Color(193, 96, 62);
Color BEACH      = Color(179, 224, 254);
Color FOREST     = Color(99, 169, 116);
Color JUNGLE     = Color(98, 126, 62);

RGBQUAD* biome(double value) 
{
    if (value < 0.10) return &DEEP_WATER;        
    else if (value < 0.20) return &WATER;        
    else if (value < 0.30) return &BEACH;
    else if (value < 0.40) return &FOREST;
    else return &JUNGLE;
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
            
        immutable octaves = (0.15 + 0.10 + 0.05);
            
        for (int y = 0; y < this.m_height; y++) 
        {
            for (int x = 0; x < this.m_width; x++)
            {
                double nx = x / cast(double)this.m_width - 0.5;
                double ny = y / cast(double)this.m_height - 0.5;

                auto e = 
                    (0.15 * this.noise( 8 * nx,  8 * ny )
                    + 0.10 * this.noise( 64 * nx, 64 * ny )
                    + 0.05 * this.noise( 128 * nx, 128 * ny ));

                e /= octaves;

                data[x][y] = e;
            }
        }

        return data;
    } 
}

void main()
{
    DerelictFI.load();
	
    int width = 512;
    int height = 512;

    auto coloredBitmap = new Bitmap(width, height);

    auto circle = GradientGenerator.radial(0, 0, width / 2);    
    auto noise = (new MyNoise(width, height)).generate();

    /** 
     * The weight applied to a vs b
     * 2.0 will double the contribution of a to the result
     * 0.5 will do the exact opposite
     */
    auto weight = 0.80;

    for (int y = 0; y < height; y++) 
    {
        for (int x = 0; x < width; x++)
        {
            auto a = circle[x][y];            
            auto b = noise[x][y];

            auto value = ((a * weight) + (b * 1.0 / weight)) / 2.0;

            // Water level, smaller value less water
            value = pow(value, 2.00);

            coloredBitmap[x, y] = biome(value);
        }
    }

    coloredBitmap.save("colored.png");
    coloredBitmap.dispose();

	DerelictFI.unload();
}