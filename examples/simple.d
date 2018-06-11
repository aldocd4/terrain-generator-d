import std.math : pow;

import derelict.freeimage.freeimage;

import tgd.Bitmap;
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

void main()
{
    DerelictFI.load();
    
    int width = 512;
    int height = 512;

    auto coloredBitmap = new Bitmap(width, height);
    auto noise = (new Noise(width, height)).generate();

    for (int y = 0; y < height; y++) 
    {
        for (int x = 0; x < width; x++)
        {
            auto n = noise[x][y];

            // Water level, smaller value less water            
            auto value = pow(n, 2.0);

            coloredBitmap[x, y] = biome(value);
        }
    }

    coloredBitmap.save("colored.png");
    coloredBitmap.dispose();

    DerelictFI.unload();
}