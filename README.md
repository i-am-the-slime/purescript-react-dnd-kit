# purescript-react-dnd-kit

PureScript bindings for [dnd-kit](https://dndkit.com/) (experimental `v0.2.x` branch) via `react-basic-hooks`.

> **Important**: This library wraps the **experimental** version of dnd-kit (`@dnd-kit/react@^0.2.4`), not the stable v5 release. The experimental API is a ground-up rewrite and is not backwards-compatible.

## Installation

Install the PureScript package:

```
spago install react-dnd-kit
```

Install the required npm packages:

```
npm install @dnd-kit/react@^0.2.4 @dnd-kit/dom@^0.2.4 @dnd-kit/abstract@^0.2.4 @dnd-kit/collision@^0.2.4 @dnd-kit/helpers@^0.2.4
```

## Quick start

```purescript
module Example where

import Prelude
import React.Basic.Hooks (component, (/\))
import React.Basic.Hooks as Hooks
import React.Basic.DOM as R
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDraggable, useDroppable)
import React.DndKit.Sensors (pointerSensorDefault)
import React.DndKit.Plugins (feedback, preventSelection)
import React.DndKit.Types (DraggableId(..), DroppableId(..))

mkApp = component "App" \_ -> Hooks.do
  pure $ dragDropProvider
    { sensors: [ pointerSensorDefault ]
    , plugins: [ feedback, preventSelection ]
    , children: [ -- your draggable and droppable components ]
    }

mkDraggableItem = component "DraggableItem" \_ -> Hooks.do
  { ref, handleRef } <- useDraggable { id: DraggableId "item-1" }
  pure $ R.div { ref, children: [ R.text "Drag me" ] }

mkDropZone = component "DropZone" \_ -> Hooks.do
  { ref, isDropTarget } <- useDroppable { id: DroppableId "zone-1" }
  pure $ R.div { ref, children: [ R.text if isDropTarget then "Drop here!" else "Drop zone" ] }
```

All config props are optional (except `id`). Pass only what you need:

```purescript
-- minimal
useDraggable { id: DraggableId "a" }

-- with options
useDraggable { id: DraggableId "a", type: "card", disabled: true, data: { color: "red" } }
```

## Modules

| Module | Exports |
|---|---|
| `React.DndKit` | `dragDropProvider`, `dragOverlay` |
| `React.DndKit.Hooks` | `useDraggable`, `useDroppable`, `useDragDropMonitor`, `useDragOperation` |
| `React.DndKit.Sortable` | `useSortable`, `SortableId` |
| `React.DndKit.Sensors` | `pointerSensor`, `keyboardSensor`, `distanceConstraint`, `delayConstraint` |
| `React.DndKit.Plugins` | `accessibility`, `autoScroller`, `cursor`, `feedback`, `preventSelection` |
| `React.DndKit.Modifiers` | `restrictToVerticalAxis`, `restrictToHorizontalAxis`, `restrictToWindow`, `restrictToElement`, `snap` |
| `React.DndKit.Collision` | `defaultCollisionDetection`, `closestCenter`, `closestCorners`, `pointerIntersection`, `shapeIntersection`, `directionBiased`, `pointerDistance` |
| `React.DndKit.Helpers` | `move`, `swap`, `arrayMove`, `arraySwap` |
| `React.DndKit.Types` | `DraggableId`, `DroppableId`, `CallbackRef`, `Coordinates`, `DragOperationSnapshot`, event types, opaque types |

## Sortable lists

```purescript
import React.DndKit.Sortable (useSortable, SortableId(..))
import React.DndKit.Helpers (move)

mkSortableItem = component "SortableItem" \{ id, index } -> Hooks.do
  { ref, handleRef, isDragging } <- useSortable { id: SortableId id, index }
  pure $ R.div { ref, children: [ R.text id ] }
```

Use `move` or `swap` from `React.DndKit.Helpers` in your `onDragOver`/`onDragEnd` handlers to reorder items.

## Event handlers

All event handlers receive the event and the `DragDropManager`, curried:

```purescript
dragDropProvider
  { sensors: [ pointerSensorDefault ]
  , plugins: [ feedback ]
  , onDragStart: \event manager -> do
      log $ "Drag started from: " <> show event.operation.source
  , onDragEnd: \event manager -> do
      when (not event.canceled) do
        -- reorder your state
        pure unit
  , children: [ ... ]
  }
```

## Type safety

Draggable, droppable, and sortable IDs are distinct newtypes and cannot be mixed:

```purescript
DraggableId "x" :: DraggableId  -- for useDraggable
DroppableId "y" :: DroppableId  -- for useDroppable
SortableId  "z" :: SortableId   -- for useSortable
```

Hook results return opaque `CallbackRef` values. Pass them as `ref` props on your DOM elements.

## License

MIT
