package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

class ActiveEntity extends Entity
{
    private var sprite:Spritemap;

    public function new(x:Int, y:Int)
    {
        super(x, y);
    }

    public function finishInitializing()
    {
        sprite.smooth = false;
        graphic = sprite;
    }

    public override function update()
    {
        super.update();
    }
}
