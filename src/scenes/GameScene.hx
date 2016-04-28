package scenes;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;
import com.haxepunk.graphics.Image;
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
        addGraphic(new Backdrop("graphics/background.png"));
        addGraphic(new Image("graphics/moss.png"));
        add(new Level("maps/castle.tmx"));
        addGraphic(new Image("graphics/greenery.png"));
        add(new Player(230, 400));
        addGraphic(new Image("graphics/decoration.png"));
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
