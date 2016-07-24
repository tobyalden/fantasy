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
        var level:Level = new Level("maps/castle.tmx");
        add(level);
        addGraphic(new Image("graphics/background_all.png"), Level.BACKGROUND);

        /*var waterfall = new Decoration(2424, 158, new Spritemap("graphics/waterfall.png", 50, 300));
          waterfall.sprite.add("cascade", [0, 10, 1, 11, 2, 12, 3, 13, 4,  14, 5, 15, 6, 16, 7, 17, 8, 18, 9, 19], 7);
        waterfall.sprite.play("cascade");
        add(waterfall);

        var mist = new Decoration(2406, 430, new Spritemap("graphics/mist.png", 75, 54));
        mist.sprite.add("splash", [0, 1, 2, 3, 4], 7);
        mist.sprite.play("splash");
        add(mist);*/

        add(new Player(230, 400));
        for (entity in level.entities)
        {
          add(entity);
        }

    }

    public override function update()
    {
      super.update();
      Timer.updateAll();
    }

}
