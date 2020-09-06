# Pongo  
_Reactive-ish ECS Game Framework built on top of Kha_

**Pongo**

Pongo is getting a huge update. The reactive part is being taken out for a moment until the core system is defined. Then "onAdded", "onRemoved", and "onChanged" calls will be re-added.


### Example Usage
---
```haxe
package;

import pongo.display.FillSprite;
import pongo.display.Sprite;
import pongo.platform.Pongo;
import pongo.ecs.Component;

class Main 
{
    public static function main() : Void
    {
        Pongo.create("Game Template", 800, 600, {}, function(pongo) {
            pongo.ecs.addSystem((dt :Float, a :Component<Sprite>) -> {
                a.value.rotation += 1 * dt;
            });

            pongo.root.addChild(new FillSprite(0xffff0000, 50, 50).setXY(100, 100).centerAnchor());

            var e = pongo.ecs.createEntity();
            e.addComponent(pongo.root.firstChild);
        });
    }
}
```
