package entities;

import com.haxepunk.tmx.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Level extends TmxEntity
{

    public static inline var FOREGROUND = 0;
    public static inline var MIDDLEFOREGROUND = 25;
    public static inline var MIDDLEGROUND = 50;
    public static inline var MIDDLEBACKGROUND = 75;
    public static inline var BACKGROUND = 100;
    public static inline var DEBUG = 999;

    public var entities:Array<Entity>;

    public function new(filename:String)
    {
        super(filename);
        layer = DEBUG;
        entities = new Array<Entity>();
        loadGraphic("graphics/tiles.png", ["solids"]);
        loadMask("solids", "walls");
        map = TmxMap.loadFromFile(filename);
        for(entity in map.getObjectGroup("entities").objects)
        {
            if(entity.type == "player") {
              entities.push(new Player(entity.x, entity.y));
            }
            else if(entity.type == "decoration") {
              if(entity.custom.resolve("isAnimated") == "true") {
                var decoration:Decoration = new Decoration(
                  entity.x,
                  entity.y,
                  new Spritemap("graphics/" + entity.name +  ".png", entity.width, entity.height)
                );
                if(entity.custom.resolve("sfx") != null) {
                  decoration.setSfx(entity.custom.resolve("sfx"));
                }
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
