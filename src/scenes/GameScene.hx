package scenes;

import com.haxepunk.Scene;
import entities.Level;
import entities.Player;

class GameScene extends Scene
{

    public function new()
    {
        super();
    }

    public override function begin()
    {
        add(new Level("maps/cave.tmx"));
        add(new Player(50, 50));
    }

}
