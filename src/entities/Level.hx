package entities;

import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

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
        for(entity in map.getObjectGroup("entities").objects)
        {
            if(entity.type == "decoration") {
              if(entity.custom.resolve("isAnimated") == "true") {
                var decoration:Decoration = new Decoration(
                  entity.x,
                  entity.y,
                  new Spritemap("graphics/" + entity.name +  ".png", entity.width, entity.height)
                );
                entities.push(decoration);
                var stringSequence:Array<String> = entity.custom.resolve("sequence").split(",");
                var intSequence:Array<Int> = new Array<Int>();
                for (char in stringSequence) {
                  intSequence.push(Std.parseInt(char));
                }
                var fps:Int = Std.parseInt(entity.custom.resolve("fps"));
                decoration.sprite.add("idle", intSequence, fps);
                decoration.sprite.play("idle");
              } else {

              }
            }
            else if(entity.type == "water") {
              entities.push(new Water(entity.x, entity.y, entity.width, entity.height));
            }
        }
    }
}

/*var waterfall = new Decoration(2424, 158, new Spritemap("graphics/waterfall.png", 50, 300));
  waterfall.sprite.add("cascade", [0, 10, 1, 11, 2, 12, 3, 13, 4,  14, 5, 15, 6, 16, 7, 17, 8, 18, 9, 19], 7);
waterfall.sprite.play("cascade");
add(waterfall);*/
