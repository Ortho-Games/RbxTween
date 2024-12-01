## **RbxTween**

RbxTween is a powerful, flexible, and easy-to-use tweening library for Roblox, providing smooth animations and powerful easing functions. With support for customizable easing styles, directions, and timelines, RbxTween allows you to create stunning animations with minimal code. It’s ideal for game developers and UI designers who want to make their games more interactive and visually engaging.

### **Features**

- **Easy-to-Use API**: With just a few function calls, you can animate properties of any Roblox object.
- **Multiple Easing Styles**: Includes pre-defined easing functions like `linear`, `quad`, `cubic`, `sine`, `elastic`, and `bounce`.
- **Custom Easing Functions**: Register your own easing styles and directions for complete control over animations.
- **Timeline Support**: Easily chain multiple animations together in a sequence with the `timeline` function.
- **Direction Control**: Supports easing directions like `in`, `out`, and `inOut` for a variety of animation effects.
- **Universal Interpolation**: Handles a variety of property types, including `Vector3`, `Color3`, and `number` interpolation.
- **Fully Type-Checked**: The library includes TypeScript-style type annotations for better development experience with type checking and IntelliSense.

### **Installation**

To use RbxTween in your Roblox project, simply require the module in your scripts (src/init.luau):

```lua
local RbxTween = require(Path.To.RbxTween)
```

### **Usage**

Here’s a simple example of how to use RbxTween to animate a part's position:

```lua
local RbxTween = require(Path.To.RbxTween)

local part = workspace.Part

RbxTween.to(part, 2, {
    Position = Vector3.new(10, 10, 10),
    ease = "sine",
    direction = "inOut",
    onStart = function() 
        print("Animation started!")
    end,
    onComplete = function() 
        print("Animation completed!")
    end
})
```

#### **Animating with Timeline**

You can chain multiple animations into a sequence using the timeline API:

```lua
local timeline = RbxTween.timeline()

timeline:add(workspace.Part, 2, {
    Position = Vector3.new(10, 10, 10),
    ease = "quad",
    direction = "in"
})
timeline:add(workspace.Part, 3, {
    Position = Vector3.new(20, 10, 10),
    ease = "elastic",
    direction = "out"
})

timeline:play()
```

#### **Custom Easing Styles**

You can register custom easing styles for more control over the animation:

```lua
RbxTween.registerEaseStyle("zigzag", {
    {0, 0},
    {0.2, 0.6},
    {0.4, 0.3},
    {0.6, 0.8},
    {0.8, 0.4},
    {1, 1},
})

RbxTween.to(workspace.Part, 2, {
    Position = Vector3.new(10, 10, 10),
    ease = "zigzag",
    direction = "inOut",
    onComplete = function() 
        print("Zigzag animation complete!")
    end
})
```

### **API**

#### **RbxTween.to(target, duration, properties)**

Animates the properties of a given target.

- `target`: The Roblox object to animate (e.g., `workspace.Part`).
- `duration`: The duration of the animation in seconds.
- `properties`: A table of properties to animate (e.g., `{ Position = Vector3.new(10, 10, 10), ease = "sine" }`).

#### **RbxTween.timeline()**

Creates a new timeline to sequence multiple animations.

- **.add(target, duration, properties)**: Adds an animation to the timeline.
- **.play()**: Plays all animations in the timeline in sequence.
- **.onComplete**: A callback to be executed when the timeline is done.

#### **RbxTween.registerEaseStyle(name, easeFunction)**

Registers a new easing style. The easing function should accept a time value `t` (between 0 and 1) and return a value representing the eased position.

#### **RbxTween.registerEaseDirection(name, directionFunction)**

Registers a new easing direction. The direction function takes an easing function as input and returns a new easing function that applies the direction to it.

### **Examples**

#### **Basic Animation**
```lua
RbxTween.to(workspace.Part, 3, {
    Position = Vector3.new(20, 10, 10),
    ease = "elastic",
    direction = "out",
})
```

#### **Multiple Animations in Sequence (Timeline)**
```lua
local timeline = RbxTween.timeline()
timeline:add(workspace.Part, 2, {
    Position = Vector3.new(10, 10, 10),
    ease = "sine",
    direction = "in"
})
timeline:add(workspace.Part, 2, {
    Position = Vector3.new(20, 10, 10),
    ease = "quad",
    direction = "out"
})
timeline:play()
```
