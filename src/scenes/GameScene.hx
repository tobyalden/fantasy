package scenes;

import com.haxepunk.*;
import com.haxepunk.utils.*;
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
        addGraphic(new Image("graphics/foreground_all.png"), Level.FOREGROUND);
        for (entity in level.entities)
        {
          add(entity);
        }
    }

    public override function update()
    {
      super.update();
      Timer.updateAll();
      if(Input.check(Key.P)) {
        HXP.engine.scene = new GameScene();
      }
    }

}
