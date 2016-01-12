
class "PatternMatrixMode" (Module)

PatternMatrixMode.mode = {
    SELECT        = 0,  -- select patterns and scenes
    COPY_PATTERN  = 1,  -- copy pattern
    INSERT_SCENE  = 2,  -- insert an empty scene
    CLEAR_PATTERN = 3,  -- clear a pattern
    REMOVE_SCENE  = 4,  -- remove a scene
}


function PatternMatrixMode:__init()
    Module:__init(self)
    self.current = PatternMatrixMode.mode.SELECT
    self.current_observable = renoise.Document.ObservableBang()
end

function PatternMatrixMode:set_copy()
    print("pattern matrix set : copy")
    self.current = PatternMatrixMode.mode.COPY_PATTERN
    self.current_observable:bang()
end
function PatternMatrixMode:set_clear()
    print("pattern matrix set : clear")
    self.current = PatternMatrixMode.mode.CLEAR_PATTERN
    self.current_observable:bang()
end
function PatternMatrixMode:reset()
    print("pattern matrix set : select")
    self.current = PatternMatrixMode.mode.SELECT
    self.current_observable:bang()
end

function PatternMatrixMode:is_meta()
   if self.current == PatternMatrixMode.mode.INSERT_SCENE then return true end
   if self.current == PatternMatrixMode.mode.REMOVE_SCENE then return true end
   return false
end

function PatternMatrixMode:is_normal()
    return not self:is_meta()
end

function PatternMatrixMode:is_copy()
    return self.current == PatternMatrixMode.mode.COPY_PATTERN
end
function PatternMatrixMode:is_clear()
    return self.current == PatternMatrixMode.mode.CLEAR_PATTERN
end
function PatternMatrixMode:is_select()
    return self.current == PatternMatrixMode.mode.SELECT
end
function PatternMatrixMode:is_insert_scene()
    return self.current == PatternMatrixMode.mode.INSERT_SCENE
end
function PatternMatrixMode:is_remove_scene()
    return self.current == PatternMatrixMode.mode.REMOVE_SCENE
end
function PatternMatrixMode:is_copy()
    return self.current == PatternMatrixMode.mode.COPY_PATTERN
end

function PatternMatrixMode:meta()
    if self.current == PatternMatrixMode.mode.COPY_PATTERN then
        print("pattern matrix set : insert scene")
        self.current = PatternMatrixMode.mode.INSERT_SCENE
    elseif self.current == PatternMatrixMode.mode.CLEAR_PATTERN then
        print("pattern matrix set : remove scene")
        self.current = PatternMatrixMode.mode.REMOVE_SCENE
    else
        self.current = PatternMatrixMode.mode.SELECT
    end
    self.current_observable:bang()
end

function PatternMatrixMode:normal()
    if self.current == PatternMatrixMode.mode.INSERT_SCENE then
        self.current = PatternMatrixMode.mode.COPY_PATTERN
    elseif self.current == PatternMatrixMode.mode.REMOVE_SCENE then
        self.current = PatternMatrixMode.mode.CLEAR_PATTERN
    else
        self.current = PatternMatrixMode.mode.SELECT
    end
    self.current_observable:bang()
end

