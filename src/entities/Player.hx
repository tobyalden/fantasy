package entities;

import flash.system.System;
import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import fantasyUtils.*;
import entities.Level;

class Player extends ActiveEntity
{
    public static inline var RUN_SPEED = 0.17 * 1000 * 0.32;
    public static inline var MAX_RUN_SPEED = 0.17 * 1000;
    public static inline var AIR_STOP_SPEED = 0.18 * 10000;
    public static inline var CLIMB_UP_SPEED = 0.14 * 1000;
    public static inline var SLIDE_DOWN_SPEED = 0.14 * 1000 * 1.1 * 1.1;
    public static inline var GRAVITY = 0.00067 * 1000 * 1000 * 1.21;
    public static inline var MAX_FALL_SPEED = 0.28 * 1000 * 1.8;
    public static inline var JUMP_POWER = 0.29 * 1000 * 1.1;
    public static inline var WALL_JUMP_POWER = 0.29 * 1000 * 1;
    public static inline var JUMP_CANCEL_POWER = 0.08 * 1000;

    public static inline var HOVERBOARD_SPEED  = 0.027 * 1000 * 0.32;
    public static inline var MAX_HOVERBOARD_SPEED = 0.27 * 1000;
    public static inline var HOVERBOARD_JUMP_POWER = 0.32 * 1000 * 1.1;
    public static inline var HOVER_HEIGHT = 10;
    public static inline var HOVER_POWER = 0.00067 * 1000 * 1000 * 1 / 5;

    private var sfx:Map<String,Sfx>;
    private var wasOnGround:Bool;
    private var wasOnWall:Bool;

    private var isInWater:Bool;
    private var wasInWater:Bool;

    private var isHoverboarding:Bool;

    private var startX:Int;
    private var startY:Int;

    public function new(x:Int, y:Int)
    {
        startX = x;
        startY = y;
        Data.load('fantasy_save');
        x = Data.read('saveX', 0);
        y = Data.read('saveY', 0);
        super(x, y);
        name = "player";
        layer = Level.MIDDLEGROUND;
        setHitbox(12, 24, -6, 0);
        sprite = new Spritemap("graphics/player.png", 24, 24);
        sprite.add("idle", [0]);
        sprite.add("run", [1, 2, 3, 2], 10);
        sprite.add("jump", [4]);
        sprite.add("climb", [5, 6, 7], 9);
        sprite.add("edge", [6]);
        sprite.add("hoverboard", [10, 11, 12], 9);
        sprite.play("idle");
        sfx = new Map<String,Sfx>();
        sfx.set("jump", new Sfx("audio/jump2.wav"));
        sfx.set("run", new Sfx("audio/run2.wav"));
        sfx.set("land", new Sfx("audio/land2.wav"));
        sfx.set("climb", new Sfx("audio/climb.wav"));
        sfx.set("slide", new Sfx("audio/slide.wav"));
        sfx.set("climbland", new Sfx("audio/climbland.wav"));
        sfx.set("climbjump", new Sfx("audio/climbjump.wav"));
        sfx.set("headbonk", new Sfx("audio/headbonk.wav"));
        sfx.set("waterrun", new Sfx("audio/waterrun.wav"));
        sfx.set("waterjump", new Sfx("audio/waterjump.wav"));
        sfx.set("waterland", new Sfx("audio/waterland.wav"));
        sfx.set("hoverboard", new Sfx("audio/hoverboard.wav"));
        wasOnGround = false;
        wasOnWall = false;
        isInWater = false;
        wasInWater = false;
        isHoverboarding = false;
        finishInitializing();
    }

    public override function update()
    {
        super.update();

        isInWater = collide('water', x, y) != null;

        movement();

        if(Input.pressed(Key.ESCAPE))
        {
          Data.write("saveX", x);
          Data.write("saveY", y);
          Data.save('fantasy_save');
          System.exit(0);
        }

        wasOnGround = isOnGround();
        wasOnWall = isOnWall();
        if(isHoverboarding) {
            moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");
        }
        else {
          moveBy(velocity.x * HXP.elapsed, velocity.y * HXP.elapsed, "walls");
        }

        animate();
        if(isHoverboarding) {
          playHoverboardSfx();
        }
        else {
          playSfx();
        }

        wasInWater = isInWater;

        HXP.camera.x = (Math.floor(centerX / HXP.width)) * HXP.width;
        HXP.camera.y = (Math.floor(centerY / HXP.height)) * HXP.height;

        debug();
    }

    private function movement()
    {
      if(Input.pressed(Key.X))
      {
        isHoverboarding = !isHoverboarding;
        stopAllSfx();
      }
      if(isHoverboarding) {
        hoverboardMovement();
      }
      else {
        runMovement();
      }
    }

    private function runMovement() {
      if(Input.check(Key.LEFT))
      {
        if(!isOnGround() && velocity.x == -MAX_HOVERBOARD_SPEED) {
          velocity.x = Math.max(velocity.x - RUN_SPEED, -MAX_HOVERBOARD_SPEED);
        }
        else {
          velocity.x = Math.max(velocity.x - RUN_SPEED, -MAX_RUN_SPEED);
        }
        sprite.flipped = true;
      }
      else if(Input.check(Key.RIGHT))
      {
        if(!isOnGround() && velocity.x == MAX_HOVERBOARD_SPEED) {
          velocity.x = Math.min(velocity.x + RUN_SPEED, MAX_HOVERBOARD_SPEED);
        }
        else {
          velocity.x = Math.min(velocity.x + RUN_SPEED, MAX_RUN_SPEED);
        }
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
        if(!Input.check(Key.LEFT) && isOnRightWall() || !Input.check(Key.RIGHT) && isOnLeftWall()) {
          velocity.x = 0;
        }

        if(Input.check(Key.UP))
        {
          if(Input.check(Key.LEFT) && isOnRightWall() || Input.check(Key.RIGHT) && isOnLeftWall())
          {
            var direction:Int = (isOnRightWall())? -1: 1;
            velocity.x = WALL_JUMP_POWER * direction;
            velocity.y = -WALL_JUMP_POWER;
            sfx.get("climbjump").play();
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
        if(isOnCeiling() && !isOnWall())
        {
          velocity.y = JUMP_CANCEL_POWER/5;
          if(!sfx.get("headbonk").playing)
          {
            sfx.get("headbonk").play();
          }
        }
        velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
      }

      if(Input.pressed(Key.UP) && isOnGround())
      {
          velocity.y = -JUMP_POWER;
          velocity.x *= 1.2;
          if(isInWater)
          {
            sfx.get("waterjump").play();
          }
          else
          {
            sfx.get("jump").play();
          }
      }
      else if(Input.released(Key.UP))
      {
        if(velocity.y < -JUMP_CANCEL_POWER)
        {
          velocity.y = -JUMP_CANCEL_POWER;
        }
      }
    }

    private function hoverboardMovement() {
      var isJustAboveGround:Bool = collide("walls", x, y + HOVER_HEIGHT) != null;
      var isAboveGround:Bool = collide("walls", x, y + HOVER_HEIGHT*2) != null;
      if(isOnWall()) {
        velocity.x = 0;
      }
      if(Input.check(Key.LEFT))
      {
        velocity.x = Math.max(velocity.x - HOVERBOARD_SPEED, -MAX_HOVERBOARD_SPEED);
        sprite.flipped = true;
      }
      else if(Input.check(Key.RIGHT))
      {
        velocity.x = Math.min(velocity.x + HOVERBOARD_SPEED, MAX_HOVERBOARD_SPEED);
        sprite.flipped = false;
      }
      if(isOnCeiling())
      {
        velocity.y += JUMP_CANCEL_POWER;
        if(!sfx.get("headbonk").playing)
        {
          sfx.get("headbonk").play();
        }
      }
      if(isOnGround()) {
        velocity.y = -HOVER_POWER * 20 * HXP.elapsed;
      }
      else if(isInWater || isJustAboveGround) {
        velocity.y = velocity.y - HOVER_POWER * HXP.elapsed;
      }
      else {
        velocity.y = Math.min(velocity.y + GRAVITY * HXP.elapsed, MAX_FALL_SPEED);
      }
      if(Input.pressed(Key.UP) && (isOnGround() || isAboveGround))
      {
          velocity.y = velocity.y/2 - HOVERBOARD_JUMP_POWER;
          velocity.x *= 1.2;
          if(isInWater)
          {
            sfx.get("waterjump").play();
          }
          else
          {
            sfx.get("jump").play();
          }
      }
      else if(Input.released(Key.UP))
      {
        if(velocity.y < -JUMP_CANCEL_POWER)
        {
          velocity.y = -JUMP_CANCEL_POWER;
        }
      }
    }

    private function debug()
    {
      if(Input.pressed(Key.R))
      {
        x = startX;
        y = startY;
      }
      if(Input.pressed(Key.W))
      {
        y -= HXP.screen.height;
      }
      if(Input.pressed(Key.A))
      {
        x -= HXP.screen.width;
      }
      if(Input.pressed(Key.S))
      {
        y += HXP.screen.height;
      }
      if(Input.pressed(Key.D))
      {
        x += HXP.screen.width;
      }
    }

    private function animate()
    {
        if(isHoverboarding) {
          sprite.play("hoverboard");
        }
        else if(isOnEdge())
        {
          sprite.play("edge");
        }
        else if(isOnWall() && !isOnGround())
        {
          if(Input.check(Key.UP))
          {
            sprite.play("climb");
          }
          else
          {
            if(sprite.currentAnim != "climb") {
              sprite.play("climb");
            }
              sprite.stop();
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
      if(isInWater && !wasInWater)
      {
        sfx.get("waterland").play();
      }
      if(!wasOnGround && isOnGround() && !isInWater)
      {
        // TODO: If I end up having more than two surface types, refactor into state-machine function
        sfx.get("land").play();
      }
      else if(!wasOnWall && isOnWall() && !isOnGround())
      {
        sfx.get("climbland").play();
      }

      if((Input.check(Key.LEFT) || Input.check(Key.RIGHT)) && isOnGround())
      {
        if(isInWater)
        {
          sfx.get("run").stop();
          if(!sfx.get("waterrun").playing)
          {
            sfx.get("waterrun").loop();
          }
        }
        else if(!sfx.get("run").playing)
        {
          sfx.get("run").loop();
        }
      }
      else
      {
        sfx.get("run").stop();
        sfx.get("waterrun").stop();
      }

      if(Input.check(Key.UP) && isOnWall())
      {
        sfx.get("slide").stop();
        if(!sfx.get("climb").playing)
        {
          sfx.get("climb").loop();
        }
      }
      else if(Input.check(Key.DOWN) && isOnWall() && !isOnGround())
      {
        sfx.get("climb").stop();
        if(!sfx.get("slide").playing)
        {
          sfx.get("slide").loop();
        }
      }
      else
      {
        sfx.get("climb").stop();
        sfx.get("slide").stop();
      }
    }

    private function playHoverboardSfx() {
      var floor = collide("walls", x, y + HOVER_HEIGHT);
      if(floor == null) {
        var farFloor = collide("walls", x, y + HOVER_HEIGHT * 2);
        if(farFloor != null) {
          sfx.get("hoverboard").volume = 0.5;
        }
        else {
          sfx.get("hoverboard").stop();
        }
      }
      else {
        if(!sfx.get("hoverboard").playing) {
          sfx.get("hoverboard").volume = 0.75;
          sfx.get("hoverboard").loop();
        }
        if(isInWater) {
          if(!sfx.get("waterrun").playing) {
            sfx.get("waterrun").loop();
          }
        }
        else {
          sfx.get("waterrun").stop();
        }
      }
    }

    private function stopAllSfx() {
      for(_sfx in sfx) {
        _sfx.stop();
      }
    }

    private function isOnEdge()
    {
      if(isOnWall())
      {
        var tempY = y;
        moveBy(0, -height/2, "walls");
        if(!isOnWall())
        {
          y = tempY;
          return true;
        }
        y = tempY;
      }
      return false;
    }
}
