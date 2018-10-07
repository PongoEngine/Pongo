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
var origin :Origin = new Origin();
```