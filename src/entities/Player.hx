package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;

class Player extends ActiveEntity
{
    public static inline var RUN_SPEED = 0.17 * 1000;
    public static inline var GRAVITY = 0.00067 * 1000 * 1000;
    public static inline var MAX_FALL_SPEED = 0.28 * 1000;
    public static inline var JUMP_POWER = 0.29 * 1000;
    public static inline var JUMP_CANCEL_POWER = 0.08 * 1000;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        setHitbox(12, 24, -4, 0);
        sprite = new Spritemap("graphics/player.png", 24, 24);
        sprite.add("idle", [0]);
        sprite.add("run", [1, 2, 3, 2], 10);
        sprite.add("jump", [4]);
        sprite.add("climb", [5, 6, 7], 10);
        sprite.play("idle");
        finishInitializing();
    }

    public override function update()
    {
        super.update();
        if(Input.check(Key.LEFT))
        {
            velocity.x = -RUN_SPEED;
            sprite.flipped = true;
        }
        else if(Input.check(Key.RIGHT))
        {
            velocity.x = RUN_SPEED;
            sprite.flipped = false;
        }
        else
        {
            velocity.x = 0;
        }

        if(isOnGround())
        {
          velocity.y = 0;
        }
        else
        {
          velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
        }

        if(Input.check(Key.Z) && isOnGround())
        {
          velocity.y = -JUMP_POWER;
        }
        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");
        animate();
    }

    private function animate()
    {
        if(!isOnGround())
        {
            sprite.play("jump");
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
