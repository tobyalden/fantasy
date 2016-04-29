package entities;

import flash.system.System;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;
import com.haxepunk.Sfx;
import fantasyUtils.*;

class Player extends ActiveEntity
{
    public static inline var RUN_SPEED = 0.17 * 1000 * 0.32;
    public static inline var MAX_RUN_SPEED = 0.17 * 1000;
    public static inline var AIR_STOP_SPEED = 0.18 * 10000;
    public static inline var CLIMB_UP_SPEED = 0.14 * 1000;
    public static inline var SLIDE_DOWN_SPEED = 0.14 * 1000 * 1.1;
    public static inline var GRAVITY = 0.00067 * 1000 * 1000 * 1.21;
    public static inline var MAX_FALL_SPEED = 0.28 * 1000 * 1.8;
    public static inline var JUMP_POWER = 0.29 * 1000 * 1.1;
    public static inline var WALL_JUMP_POWER = 0.29 * 1000 * 1;
    public static inline var JUMP_CANCEL_POWER = 0.08 * 1000;

    private var sfx:Map<String,Sfx>;
    private var wasOnGround:Bool;
    private var wasOnWall:Bool;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        setHitbox(12, 24, -6, 0);
        sprite = new Spritemap("graphics/player.png", 24, 24);
        sprite.add("idle", [0]);
        sprite.add("run", [1, 2, 3, 2], 10);
        sprite.add("jump", [4]);
        sprite.add("climb", [5, 6, 7], 9);
        sprite.play("idle");
        sfx = new Map<String,Sfx>();
        sfx.set("jump", new Sfx("audio/jump2.wav"));
        sfx.set("run", new Sfx("audio/run2.wav"));
        sfx.set("land", new Sfx("audio/land2.wav"));
        sfx.set("climb", new Sfx("audio/climb.wav"));
        sfx.set("climbLand", new Sfx("audio/climbland.wav"));
        sfx.set("climbJump", new Sfx("audio/climbjump.wav"));
        wasOnGround = false;
        finishInitializing();
    }

    public override function update()
    {
        super.update();

        if(Input.check(Key.LEFT))
        {
          velocity.x = Math.max(velocity.x - RUN_SPEED, -MAX_RUN_SPEED);
          sprite.flipped = true;
        }
        else if(Input.check(Key.RIGHT))
        {
          velocity.x = Math.min(velocity.x + RUN_SPEED, MAX_RUN_SPEED);
          sprite.flipped = false;
        }
        else
        {
            if(isOnGround())
            {
              velocity.x = 0;
            }
            else if(velocity.x > 0)
            {
              velocity.x = Math.max(velocity.x - AIR_STOP_SPEED * HXP.elapsed, 0);
            }
            else
            {
              velocity.x = Math.min(velocity.x + AIR_STOP_SPEED * HXP.elapsed, 0);
            }
        }

        if(isOnWall())
        {
          if(Input.check(Key.UP))
          {
            if(Input.check(Key.LEFT) && isOnRightWall() || Input.check(Key.RIGHT) && isOnLeftWall())
            {
              var direction:Int = (isOnRightWall())? -1: 1;
              velocity.x = WALL_JUMP_POWER * direction;
              velocity.y = -WALL_JUMP_POWER;
              sfx.get("climbJump").play();
            }
            else
            {
              velocity.y = -CLIMB_UP_SPEED;
            }
          }
          else if(Input.check(Key.DOWN))
          {
            velocity.y = SLIDE_DOWN_SPEED;
          }
          else
          {
            velocity.y = 0;
          }
        }
        else if(isOnGround())
        {
          velocity.y = 0;
        }
        else
        {
          if(isOnCeiling())
          {
            velocity.y = 0;
          }
          velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
        }

        if(Input.pressed(Key.UP) && isOnGround())
        {
            velocity.y = -JUMP_POWER;
            velocity.x *= 1.2;
            sfx.get("jump").play();
        }
        else if(Input.released(Key.UP))
        {
          if(velocity.y < -JUMP_CANCEL_POWER)
          {
            velocity.y = -JUMP_CANCEL_POWER;
          }
        }

        if(Input.pressed(Key.ESCAPE))
        {
          System.exit(0);
        }

        wasOnGround = isOnGround();
        wasOnWall = isOnWall();
        moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");

        animate();
        playSfx();

    }

    private function animate()
    {
        if(isOnWall() && !isOnGround())
        {
          if(velocity.y == 0 || Input.check(Key.DOWN))
          {
            if(sprite.currentAnim == "climb")
            {
              sprite.stop();
            }
          }
          else
          {
            sprite.play("climb");
          }
        }
        else if(!isOnGround())
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

    private function playSfx()
    {
      if(!wasOnGround && isOnGround())
      {
        sfx.get("land").play();
      }
      else if(!wasOnWall && isOnWall() && !isOnGround())
      {
        sfx.get("climbLand").play();
      }

      if((Input.check(Key.LEFT) || Input.check(Key.RIGHT)) && isOnGround())
      {
        if(!sfx.get("run").playing)
        {
          sfx.get("run").loop();
        }
      }
      else
      {
        sfx.get("run").stop();
      }

      if(Input.check(Key.UP) && isOnWall())
      {
        if(!sfx.get("climb").playing)
        {
          sfx.get("climb").loop();
        }
      }
      else
      {
        sfx.get("climb").stop();
      }
    }
}
