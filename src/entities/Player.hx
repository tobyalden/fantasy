package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends Entity
{
    public function new(x:Int, y:Int)
    {
        super(x, y);
        graphic = new Image("graphics/block.png");
    }

    public override function update()
    {
        if (Input.check(Key.LEFT))
        {
            moveBy(-2, 0);
        }
        if (Input.check(Key.RIGHT))
        {
            moveBy(2, 0);
        }
        if (Input.check(Key.UP))
        {
            moveBy(0, -2);
        }
        if (Input.check(Key.DOWN))
        {
            moveBy(0, 2);
        }

        super.update();
    }
}
