package entities;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.Entity;

class Level extends TmxEntity
{

    public var entities:Array<Entity>;

    public function new(filename:String)
    {
        super(filename);
        entities = new Array<Entity>();
        loadGraphic("graphics/tiles.png", ["solids"]);
        loadMask("solids", "walls");
        map = TmxMap.loadFromFile(filename);
        for(entity in map.getObjectGroup("decoration").objects)
        {
            if(entity.type == "water") {
              entities.push(new Water(entity.x, entity.y, entity.width, entity.height));
            }
        }
    }
}
