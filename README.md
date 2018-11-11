# Pongo  
_Reactive-ish ECS Game Framework built on top of Kha_

**Pongo** is a frankensteined monster of a 2D game framework. It leverages concepts and code from game frameworks including Flambe, Ash, and Entitas. 

At the heart of pongo is a Simple ECS for decoupled game logic and sprite rendering.

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
import pongo.ecs.transform.Transform;
import pongo.ecs.transform.TransformSystem;
import pongo.ecs.Component;
import pongo.ecs.System;
import pongo.ecs.group.SourceGroup;
import pongo.display.FillSprite;

class Main {
    public static function main() : Void
    {
        pongo.platform.Pongo.create("Empty", 800, 400, onStart);
    }

    private static function onStart(pongo :Pongo) : Void
    {
        var transforms = pongo.manager.registerGroup([Transform]);
        var heroes = pongo.manager.registerGroup([Position, Hero, Transform]);
        pongo
            .addSystem(new TransformSystem(transforms))
            .addSystem(new HeroSystem(heroes));

        pongo.root
            .addComponent(new Transform(new FillSprite(0xff00ff00, 40, 40)))
            .addComponent(new Position(200, 200, 30))
            .addComponent(new Hero(400));
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

class HeroSystem implements System
{
    public var heroes :SourceGroup;

    public function new(heroes :SourceGroup) : Void
    {
        this.heroes = heroes;
    }

    public function update(pongo :Pongo, dt :Float) : Void
    {
        heroes.iterate(function(entity) {
            var hero :Hero = entity.getComponent(Hero);
            var pos :Position = entity.getComponent(Position);
            var transform :Transform = entity.getComponent(Transform);
            var sprite :FillSprite = cast transform.sprite;

            pos.x = (hero.speed*dt) * Math.cos(pos.angle) + pos.x;
            pos.y = (hero.speed*dt) * Math.sin(pos.angle) + pos.y;

            if(pos.y <= 0) {
                pos.angle = (-pos.angle);
                pos.y = 1;
                sprite.color = 0xff00ff00;
            }
            else if(pos.y >= pongo.window.height) {
                pos.angle = (-pos.angle);
                pos.y = pongo.window.height - 1;
                sprite.color = 0xff0000ff;
            }
            if(pos.x >= pongo.window.width) {
                pos.angle = (pos.angle+180) % 360;
                pos.x = pongo.window.width -1;
                sprite.color = 0xffffff00;
            }
            else if(pos.x <= 0) {
                pos.angle = (pos.angle+180) % 360;
                pos.x = 1;
                sprite.color = 0xffff00ff;
            }

            transform.y = pos.y;
            transform.x = pos.x;
        });
    }
}
```
