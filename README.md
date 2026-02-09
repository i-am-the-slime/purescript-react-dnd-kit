# purescript-react-dnd-kit

PureScript bindings for [dnd-kit](https://dndkit.com/) (experimental `v0.2.x` branch) via `react-basic-hooks`.

> **Important**: This library wraps the **experimental** version of dnd-kit (`@dnd-kit/react@^0.2.4`), not the stable v5 release. The experimental API is a ground-up rewrite and is not backwards-compatible.

[Pursuit documentation](https://pursuit.purescript.org/packages/purescript-react-dnd-kit)

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
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, button, p)
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDraggable, useDroppable)
import React.DndKit.Sensors (pointerSensorDefault)
import React.DndKit.Plugins (feedback, preventSelection)
import React.DndKit.Types (DraggableId(..), DroppableId(..))

app :: {} -> JSX
app = component "App" \_ -> React.do
  pure $ dragDropProvider
    { sensors: [ pointerSensorDefault ]
    , plugins: [ feedback, preventSelection ]
    }
    [ draggableItem {}
    , dropZone {}
    ]

draggableItem :: {} -> JSX
draggableItem = component "DraggableItem" \_ -> React.do
  { ref, handleRef } <- useDraggable { id: DraggableId "item-1" }
  pure $ div { ref, className: "card" } do
    button { ref: handleRef } "Grab here"

dropZone :: {} -> JSX
dropZone = component "DropZone" \_ -> React.do
  { ref, isDropTarget } <- useDroppable { id: DroppableId "zone-1" }
  pure $ div { ref } do
    p {} if isDropTarget then "Drop here!" else "Drop zone"
```

All config props are optional (except `id`). Pass only what you need:

```purescript
-- minimal
useDraggable { id: DraggableId "a" }

-- with options
useDraggable { id: DraggableId "a", type: DragType "card", feedback: clone, disabled: true, data: { color: "red" } }
```

## Modules

| Module | Exports |
|---|---|
| `React.DndKit` | `dragDropProvider`, `dragDropProvider_`, `dragOverlay`, `dragOverlay_` |
| `React.DndKit.Hooks` | `useDraggable`, `useDroppable`, `useDragDropMonitor`, `useDragOperation` |
| `React.DndKit.Sortable` | `useSortable`, `SortableId` |
| `React.DndKit.Sensors` | `pointerSensor`, `keyboardSensor`, `distanceConstraint`, `delayConstraint` |
| `React.DndKit.Plugins` | `accessibility`, `autoScroller`, `cursor`, `feedback`, `preventSelection` |
| `React.DndKit.Modifiers` | `restrictToVerticalAxis`, `restrictToHorizontalAxis`, `restrictToWindow`, `restrictToElement`, `snap` |
| `React.DndKit.Collision` | `defaultCollisionDetection`, `closestCenter`, `closestCorners`, `pointerIntersection`, `shapeIntersection`, `directionBiased`, `pointerDistance` |
| `React.DndKit.Helpers` | `move`, `swap`, `arrayMove`, `arraySwap` |
| `React.DndKit.Types` | `DraggableId`, `DroppableId`, `DragType`, `FeedbackType` (`move`, `clone`, `noFeedback`), `CallbackRef`, `Coordinates`, `DragOperationSnapshot`, event types, opaque types |

## Sortable list example

A complete sortable list that reorders items on drag:

```purescript
import Prelude
import Data.Array (findIndex, mapWithIndex)
import Data.Maybe (fromMaybe)
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import React.Basic (JSX)
import React.Basic.Hooks as React
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)
import React.DndKit (dragDropProvider)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Sensors (pointerSensorDefault)
import React.DndKit.Plugins (feedback)
import React.DndKit.Helpers (arrayMove)
import React.DndKit.Types (DraggableId(..), DroppableId(..))

sortableList :: {} -> JSX
sortableList = component "SortableList" \_ -> React.do
  items /\ setItems <- React.useState [ "Apples", "Bananas", "Oranges", "Mangoes" ]
  let
    reorder event _ = do
      let src = event.operation.source >>= \s -> findIndex (_ == un DraggableId s.id) items
      let tgt = event.operation.target >>= \t -> findIndex (_ == un DroppableId t.id) items
      case src, tgt of
        Just from, Just to -> setItems \_ -> arrayMove items from to
        _, _ -> pure unit
  pure $ dragDropProvider
    { sensors: [ pointerSensorDefault ]
    , plugins: [ feedback ]
    , onDragOver: reorder
    }
    (items # mapWithIndex \index item ->
      sortableItem { id: item, index }
    )

sortableItem :: { id :: String, index :: Int } -> JSX
sortableItem = component "SortableItem" \{ id, index } -> React.do
  { ref } <- useSortable { id: SortableId id, index }
  pure $ div { ref, className: "sortable-item" } id
```

## Event handlers

All event handlers receive the event and the `DragDropManager`:

```purescript
dragDropProvider
  { sensors: [ pointerSensorDefault ]
  , plugins: [ feedback ]
  , onDragStart: \event _manager ->
      log $ "Drag started"
  , onDragEnd: \event _manager ->
      when (not event.canceled) do
        log $ "Drag ended"
  }
  [ -- children
  ]
```

## Type safety

Draggable, droppable, and sortable IDs are distinct newtypes and cannot be mixed:

```purescript
DraggableId "x" :: DraggableId  -- for useDraggable
DroppableId "y" :: DroppableId  -- for useDroppable
SortableId  "z" :: SortableId   -- for useSortable
```

`DragType` is a newtype over `String` for type/accept matching between draggables and droppables:

```purescript
useDraggable { id: DraggableId "a", type: DragType "card" }
useDroppable { id: DroppableId "b", type: DragType "card" }
```

`FeedbackType` controls the visual feedback strategy during drag. It is opaque with smart constructors:

```purescript
import React.DndKit.Types (move, clone, noFeedback)

useSortable { id: SortableId "s", index: 0, feedback: move }
```

Hook results return opaque `CallbackRef` values. Pass them as `ref` props on your DOM elements.

## License

MIT
