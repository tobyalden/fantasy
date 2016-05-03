package scenes;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.tmx.TmxMap;
import entities.*;
import fantasyUtils.*;

class GameScene extends Scene
{

    public function new()
    {
        super();
    }

    public override function begin()
    {
      add(new Level("maps/castle.tmx"));
        addGraphic(new Backdrop("graphics/background_all.png"));
/*
        var waterfall = new Decoration(504, 158, new Spritemap("graphics/waterfall.png", 50, 300));
        waterfall.sprite.add("cascade", [0, 10, 1, 11, 2, 12, 3, 13, 4,  14, 5, 15, 6, 16, 7, 17, 8, 18, 9, 19], 7);
        waterfall.sprite.play("cascade");
        add(waterfall);

        var mist = new Decoration(486, 430, new Spritemap("graphics/mist.png", 75, 54));
        mist.sprite.add("splash", [0, 1, 2, 3, 4], 7);
        mist.sprite.play("splash");
        add(mist);*/


        add(new Player(230, 400));

        /*var water = new Decoration(16, 448, new Spritemap("graphics/water.png"));
        water.type = 'water';
        add(water);*/

        var waterfallsfx = new Sfx("audio/waterfall2.wav");
        waterfallsfx.loop();

        var map = TmxMap.loadFromFile("maps/castle.tmx");
        /*var entities = new Array<Entity>();
        for(entity in map.getObjectGroup("entities").objects)
        {
            if(entity.type == "fan")
            {
              entities.push(new Fan(entity.x, entity.y));
            }
        }*/
    }

    public override function update()
    {
      super.update();
      Timer.updateAll();
    }

}
