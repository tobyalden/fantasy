package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import flash.geom.Rectangle;
import entities.Level;

class Water extends Entity
{
    public function new(x:Int, y:Int, width:Int, height:Int)
    {
        super(x, y);
        layer = Level.FOREGROUND;
        graphic = new TiledImage("graphics/water.png", width, height);
        setHitbox(width, height);
        type = "water";
    }
}
