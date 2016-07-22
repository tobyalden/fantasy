package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import flash.geom.Rectangle;

class Water extends Entity
{
    public function new(x:Int, y:Int, width:Int, height:Int)
    {
        super(x, y);
        graphic = new TiledImage("graphics/water.png", width, height);
        this.width = width;
        this.height = height;
        type = "water";
        // maybe add some sort of animation... the image could shift around in its frame slightly
    }
}
