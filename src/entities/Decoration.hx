package entities;

import flash.geom.Point;
import com.haxepunk.*;
import com.haxepunk.graphics.Spritemap;
import entities.Level;
import fantasyUtils.*;

class Decoration extends Entity
{
    public var sprite:Spritemap;
    private var sfx:Sfx;
    private var sfxFadeOutTimer:Timer;
    private var sfxFadeInTimer:Timer;

    public static inline var FADE_OUT_TIME = 200;
    public static inline var FADE_IN_TIME = 80;

    public function new(x:Int, y:Int, sprite:Spritemap)
    {
        super(x, y);
        layer = Level.MIDDLEBACKGROUND;
        this.sprite = sprite;
        sfx = null;
        sfxFadeOutTimer = null;
        sfxFadeInTimer = null;
        graphic = sprite;
        setHitboxTo(sprite);
    }

    public override function update()
    {
        super.update();
        if(sfx != null) {
          updateSfx();
        }
    }

    public function setSfx(sfxName:String)
    {
      sfx = new Sfx("audio/" + sfxName + ".wav");
      sfx.loop();
      sfxFadeOutTimer = new Timer(FADE_OUT_TIME);
      sfxFadeInTimer = new Timer(FADE_IN_TIME);
    }


    public function updateSfx() {
      var player:Player = cast(HXP.scene.getInstance("player"), Player);
      var onSameScreen = (
        player.getScreenCoordinates().x == getScreenCoordinates().x &&
        player.getScreenCoordinates().y == getScreenCoordinates().y
      );
      if(onSameScreen || collideWith(player, x, y) != null) {
        if(sfxFadeInTimer.isActive()) {
          sfxFadeOutTimer.count = Math.floor((1 - sfxFadeInTimer.percentComplete()) * sfxFadeOutTimer.duration);
        }
        else {
          sfxFadeOutTimer.restart();
        }
        sfx.volume = 1 - sfxFadeInTimer.percentComplete();
      }
      else {
        if(sfxFadeOutTimer.isActive()) {
          sfxFadeInTimer.count = Math.floor((1 - sfxFadeOutTimer.percentComplete()) * sfxFadeInTimer.duration);
        }
        else {
          sfxFadeInTimer.restart();
        }
        sfx.volume = sfxFadeOutTimer.percentComplete();
      }
    }

    public function getScreenCoordinates() {
      return new Point(
        Math.floor(x / HXP.screen.width),
        Math.floor(y / HXP.screen.height)
      );
    }
}
