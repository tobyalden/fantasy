package entities;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.Entity;

class Level extends TmxEntity
{

    public var entities:Array<Entity>;

    public function new(filename:String)
    {
        super(filename);
        loadGraphic("graphics/tiles.png", ["main"]);
        loadMask("main", "walls");
    }
}
