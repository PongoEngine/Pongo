package pongo.ecs;

interface System {
    function update(pongo :Pongo, dt :Float) : Void;
}