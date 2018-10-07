# Pongo  
_ECS Game Framework built on top of Kha_

**Pongo** is a frankensteined monster of a 2D game framework. It leverages concepts and code from my favorite game frameworks including Flambe, Ash, and Entitas. 

At the heart of pongo is a Simple ECS for decoupled game logic and a Tree Structure for intuitive sprite rendering. Its the best of both worlds!

## Quick overview of the Pongo's ECS
- Components are pure data.
- Components are grouped together by user defined sets Ex. ([Enemy, Position], [Hero, Position]]).
- Entities hold unique Components.
- Systems run logic on iterated groups.

## Quick overview of the Tree Structure
- All Entities can have children and one parent.
- An Entitiy can have one Sprite.
- Sprites are rendered starting from the root Entity traversing through all the nodes.


### Example Usage
---
```haxe
package;

import kha.System;

import pongo.Pongo;
import pongo.ecs.Component;
import pongo.ecs.GroupedEntity;
import pongo.display.FillSprite;

class Main {
    public static function main() : Void
    {
        System.start({title: "Empty", width: 800, height: 600}, onStart);
    }

    private static function onStart(window) : Void
    {
        var pongo :Pongo = new Pongo();
        var group = pongo.engine.registerGroup("Heroes", [Position, Hero]);

        pongo.engine.root
            .setSprite(new FillSprite(0xff00ff00, 40, 40)
                .centerAnchor())
            .addComponent(new Position(200, 200, 30))
            .addComponent(new Hero(400));

        pongo.addSystem("exampleSys", updateLogic.bind(group));
    }

    private static function updateLogic(group :GroupedEntity, pongo :Pongo, dt :Float) : Void
    {
        group.manipulate(function(entity) {
            var hero :Hero = entity.getComponent(Hero);
            var pos :Position = entity.getComponent(Position);
            var sprite :FillSprite = cast entity.sprite;

            pos.x = (hero.speed*dt) * Math.cos(pos.angle) + pos.x;
            pos.y = (hero.speed*dt) * Math.sin(pos.angle) + pos.y;

            if(pos.y <= 0) {
                pos.angle = (-pos.angle);
                pos.y = 1;
                sprite.color = 0xff00ff00;
            }
            else if(pos.y >= pongo.height) {
                pos.angle = (-pos.angle);
                pos.y = pongo.height - 1;
                sprite.color = 0xff0000ff;
            }
            if(pos.x >= pongo.width) {
                pos.angle = (pos.angle+180) % 360;
                pos.x = pongo.width -1;
                sprite.color = 0xffffff00;
            }
            else if(pos.x <= 0) {
                pos.angle = (pos.angle+180) % 360;
                pos.x = 1;
                sprite.color = 0xffff00ff;
            }

            sprite.y = pos.y;
            sprite.x = pos.x;
        });
    }
}

class Position implements Component
{
    var x :Float;
    var y :Float;
    var angle :Float;
}

class Hero implements Component
{
    var speed :Float;
}
```