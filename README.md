## **RbxTween**

RbxTween is a powerful, flexible, and easy-to-use tweening library for Roblox, providing smooth animations and robust easing functions. With support for customizable easing styles, directions, timelines, and staggered animations, RbxTween allows you to create stunning, interactive animations with minimal code. It’s perfect for game developers and UI designers looking to enhance their projects with dynamic effects.

---

### **Features**

- **Easy-to-Use API**: Animate properties of any Roblox object with just a few function calls.
- **Multiple Easing Styles**: Includes pre-defined easing functions like `linear`, `quad`, `cubic`, `sine`, `elastic`, and `bounce`.
- **Custom Easing Functions**: Register your own easing styles and directions for complete animation control.
- **Timeline Support**: Chain multiple animations together in a sequence with the `timeline` function.
- **Direction Control**: Supports easing directions like `in`, `out`, and `inOut` for a variety of animation effects.
- **Staggered Animations**: Easily stagger animations across multiple objects using offsets, axes, or custom functions.
- **Repeat Animations**: Control animation loops with fixed or dynamic repeat logic.
- **Universal Interpolation**: Handles a variety of property types, including `Vector3`, `UDim`, `Color3`, and `number`.
- **Recursive Multiplication**: Supports non-standard types like `UDim` for property multiplication using recursive addition.
- **Fully Type-Checked**: Type annotations provide a better development experience with type checking and IntelliSense.

---

### **Installation**

To use RbxTween in your Roblox project, require the module in your scripts (src/init.luau):

```lua
local RbxTween = require(Path.To.RbxTween)
```

---

### **Usage**

#### **Basic Animation**

Here’s a simple example of how to animate a part's position:

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

---

### **Staggered Animations**

#### **Using Axis-Based Staggering**
Stagger properties like position, rotation, or any interpolatable value across multiple objects.

```lua
local parts = {workspace.Part1, workspace.Part2, workspace.Part3}

RbxTween.to(parts, 2, {
    Position = Vector3.new(10, 10, 10),
    stagger = { offset = 5, each = 0.5, axis = Vector3.new(1, 0, 0) },
    ease = "elastic",
    direction = "out",
    onComplete = function()
        print("Staggered animation complete!")
    end
})
```

#### **Using a Custom Stagger Function**

Define custom stagger logic using a function that returns the delay for each object based on its index or other properties.

```lua
local parts = {workspace.Part1, workspace.Part2, workspace.Part3}

RbxTween.to(parts, 2, {
    Position = Vector3.new(10, 10, 10),
    stagger = function(index, target, allTargets)
        return index * 0.3 -- Delay increases by 0.3 seconds per object
    end,
    ease = "bounce",
    direction = "inOut",
})
```

---

### **Repeating Animations**

#### **Fixed Repeat Count**

Repeat an animation a specific number of times using the `repeat` property.

```lua
local part = workspace.Part

RbxTween.to(part, 2, {
    Position = Vector3.new(10, 10, 10),
    repeat = 3, -- Animation repeats 3 times
    ease = "quad",
    direction = "in",
    onComplete = function()
        print("Animation finished repeating!")
    end
})
```

#### **Dynamic Repeat Logic**

Use a function for the `repeat` property to dynamically control whether an animation should repeat.

```lua
local part = workspace.Part

RbxTween.to(part, 2, {
    Position = Vector3.new(10, 10, 10),
    repeat = function(properties, repeatCount)
        return repeatCount < 5 -- Stop repeating after 5 cycles
    end,
    ease = "elastic",
    direction = "out",
    onComplete = function()
        print("Dynamic repeat animation complete!")
    end
})
```

---

### **Animating with Timeline**

Chain multiple animations into a sequence using the timeline API:

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

---

### **Custom Easing Styles**

Register custom easing styles for complete control over animations:

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

---

### **API**

#### **RbxTween.to(target, duration, properties)**

Animates the properties of a given target.

- `target`: The Roblox object(s) to animate (e.g., `workspace.Part` or `{workspace.Part1, workspace.Part2}`).
- `duration`: Duration of the animation in seconds.
- `properties`: A table of properties to animate (e.g., `{ Position = Vector3.new(10, 10, 10), ease = "sine" }`).
  - `stagger`: Define stagger settings using `{ offset, each, axis }` or a custom function.
  - `repeat`: Specify a fixed repeat count or a custom repeat function.

#### **RbxTween.timeline()**

Creates a new timeline to sequence multiple animations.

- **.add(target, duration, properties)**: Adds an animation to the timeline.
- **.play()**: Plays all animations in sequence.
- **.onComplete**: Callback executed when the timeline finishes.

#### **RbxTween.registerEaseStyle(name, easeFunction)**

Registers a new easing style. The easing function should accept a time value `t` (between 0 and 1) and return a value representing the eased position.

#### **RbxTween.registerEaseDirection(name, directionFunction)**

Registers a new easing direction. The direction function takes an easing function as input and returns a new easing function that applies the direction to it.

---

### **Examples**

#### **Staggered Position Animation**
```lua
local parts = {workspace.Part1, workspace.Part2, workspace.Part3}

RbxTween.to(parts, 2, {
    Position = Vector3.new(10, 10, 10),
    stagger = { offset = 5, each = 0.5, axis = Vector3.new(1, 0, 0) },
    ease = "sine",
    direction = "inOut",
})
```

#### **Repeating Animation**
```lua
local part = workspace.Part

RbxTween.to(part, 3, {
    Position = Vector3.new(20, 10, 10),
    ["repeat"] = 4, -- Repeat animation 4 times
    ease = "bounce",
    direction = "out",
})
``` 
