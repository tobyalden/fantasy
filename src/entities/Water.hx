package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import flash.geom.Rectangle;

class Water extends Entity
{
    public function new(x:Int, y:Int, width:Int, height:Int)
    {
        super(x, y);
        graphic = new Image("graphics/water.png", new Rectangle(x % HXP.screen.width, y % HXP.screen.height, width, height));
        this.width = width;
        this.height = height;
        type = "water";
    }
}
