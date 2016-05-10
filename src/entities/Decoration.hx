package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.Spritemap;

class Decoration extends Entity
{
    public var sprite:Spritemap;
    public var sfx:Sfx;

    public function new(x:Int, y:Int, sprite:Spritemap)
    {
        super(x, y);
        this.sprite = sprite;
        graphic = sprite;
        setHitboxTo(sprite);
    }

}
