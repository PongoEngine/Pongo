package pongo.display;

enum Pipeline
{
    CUSTOM(pipelineState :kha.graphics4.PipelineState, fn :kha.graphics4.Graphics -> Void);
    DEFAULT;
}