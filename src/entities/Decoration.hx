package entities;

import flash.geom.Point;
import com.haxepunk.*;
import com.haxepunk.graphics.Spritemap;
import entities.Level;

class Decoration extends Entity
{
    public var sprite:Spritemap;
    private var sfx:Sfx;

    public function new(x:Int, y:Int, sprite:Spritemap)
    {
        super(x, y);
        layer = Level.MIDDLEBACKGROUND;
        this.sprite = sprite;
        sfx = null;
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

    public function updateSfx() {
      var player:Player = cast(HXP.scene.getInstance("player"), Player);
      if(
        player.getScreenCoordinates().x == getScreenCoordinates().x &&
        player.getScreenCoordinates().y == getScreenCoordinates().y
      ) {
        if(!sfx.playing) {
          sfx.resume();
        }
      }
      else {
        sfx.stop();
      }
    }

    public function setSfx(sfxName:String)
    {
      sfx = new Sfx("audio/" + sfxName + ".wav");
      sfx.loop();
    }

    public function getScreenCoordinates() {
      return new Point(
        Math.floor(x / HXP.screen.width),
        Math.floor(y / HXP.screen.height)
      );
    }
}
