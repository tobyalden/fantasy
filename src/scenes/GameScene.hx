package scenes;

import com.haxepunk.Scene;
import com.haxepunk.Entity;
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
        add(new Player(200, 400));
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
