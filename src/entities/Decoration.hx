package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.Spritemap;
import entities.Level;

class Decoration extends Entity
{
    public var sprite:Spritemap;
    public var sfx:Sfx;

    public function new(x:Int, y:Int, sprite:Spritemap)
    {
        super(x, y);
        layer = Level.MIDDLEBACKGROUND;
        this.sprite = sprite;
        graphic = sprite;
        setHitboxTo(sprite);
    }
}
