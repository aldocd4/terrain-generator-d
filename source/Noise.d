module tgd.Noise;

import std.random;
import std.datetime;

import tgd.Math;
import dosimplex.generator;

class Noise
{
    protected int m_width;
    protected int m_height;

    protected SNoiseGenerator m_simplexNoise;

    public this(in int width, in int height)
    {
        this.m_width = width; 
        this.m_height = height;

        auto random = Random(cast(uint)MonoTime.currTime.ticks);
        this.m_simplexNoise = SNoiseGenerator(uniform(1, 19999999));
    }

    public double[][] generate()
    {
        double[][] data = new double[][](this.m_width, this.m_height);
            
        immutable octaves = (1.00 + 0.70 + 0.40 + 0.20 + 0.10 + 0.05);
            
        for (int y = 0; y < this.m_height; y++) 
        {
            for (int x = 0; x < this.m_width; x++)
            {
                double nx = x / cast(double)this.m_width - 0.5;
                double ny = y / cast(double)this.m_height - 0.5;

                auto e = 
                    (1.00 * this.noise( 1 * nx,  1 * ny )
                    + 0.70 * this.noise( 4 * nx,  4 * ny )                
                    + 0.40 * this.noise( 8 * nx,  8 * ny )
                    + 0.20 * this.noise( 16 * nx, 16 * ny )                
                    + 0.10 * this.noise( 32 * nx, 32 * ny )
                    + 0.05 * this.noise( 64 * nx, 64 * ny ));

                e /= octaves;

                data[x][y] = e;
            }
        }

        return data;
    }

    public double noise(in double x, in double y) 
    {
        // Rescale from -1.0:+1.0 to 0.0:1.0
        return this.m_simplexNoise.noise2D(x, y) / 2 + 0.5;
    }
}