package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;

class Player extends ActiveEntity
{
    public static inline var RUN_SPEED = 2;
    public static inline var GRAVITY = 2;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        setHitbox(30, 48, -19, -12);
        sprite = new Spritemap("graphics/player.png", 30, 30);
        sprite.scale = 2;
        sprite.add("idle", [0]);
        sprite.add("run", [1, 2, 3], 10);
        sprite.add("jump", [4]);
        sprite.add("fall", [5]);
        sprite.play("idle");
        finishInitializing();
    }

    public override function update()
    {
        super.update();
        if (Input.check(Key.LEFT))
        {
            velocity.x = -RUN_SPEED;
            sprite.flipped = true;
        }
        else if (Input.check(Key.RIGHT))
        {
            velocity.x = RUN_SPEED;
            sprite.flipped = false;
        }
        else
        {
            velocity.x = 0;
        }
        velocity.y = GRAVITY;
        moveBy(velocity.x, velocity.y, "walls");
        animate();
    }

    private function animate()
    {
        if(!isOnGround())
        {
            if(velocity.y < 0)
            {
                sprite.play("jump");
            }
            else
            {
                sprite.play("fall");
            }
        }
        else if(velocity.x != 0)
        {
            sprite.play("run");
        }
        else
        {
            sprite.play("idle");
        }
    }
}
