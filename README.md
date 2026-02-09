# purescript-react-dnd-kit

PureScript bindings for [dnd-kit](https://dndkit.com/) (experimental `v0.2.x` branch) via `react-basic-hooks`.

> **Important**: This library wraps the **experimental** version of dnd-kit (`@dnd-kit/react@^0.2.4`), not the stable v5 release. The experimental API is a ground-up rewrite and is not backwards-compatible.

[Pursuit documentation](https://pursuit.purescript.org/packages/purescript-react-dnd-kit)

## Installation

```
spago install react-dnd-kit
```

```
npm install @dnd-kit/react@^0.2.4 @dnd-kit/dom@^0.2.4 @dnd-kit/abstract@^0.2.4 @dnd-kit/collision@^0.2.4 @dnd-kit/helpers@^0.2.4
```

## Sortable list

```purescript
import Prelude
import Data.Array (findIndex, mapWithIndex)
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

## Drag and drop

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
    [ draggableCard {}
    , dropZone {}
    ]

draggableCard :: {} -> JSX
draggableCard = component "DraggableCard" \_ -> React.do
  { ref, handleRef } <- useDraggable { id: DraggableId "item-1" }
  pure $ div { ref, className: "card" } do
    button { ref: handleRef } "Grab here"

dropZone :: {} -> JSX
dropZone = component "DropZone" \_ -> React.do
  { ref, isDropTarget } <- useDroppable { id: DroppableId "zone-1" }
  pure $ div { ref } do
    p {} if isDropTarget then "Drop here!" else "Drop zone"
```

## Type matching

```purescript
import React.DndKit.Types (DragType(..))

-- only "card" draggables can be dropped on "card" droppables
draggable :: {} -> JSX
draggable = component "Draggable" \_ -> React.do
  { ref } <- useDraggable { id: DraggableId "a", type: DragType "card" }
  pure $ div { ref } "Card"

target :: {} -> JSX
target = component "Target" \_ -> React.do
  { ref } <- useDroppable { id: DroppableId "b", type: DragType "card" }
  pure $ div { ref } "Drop cards here"
```

## Feedback

```purescript
import React.DndKit.Types (move, clone, noFeedback)

moveItem :: { id :: String, index :: Int } -> JSX
moveItem = component "MoveItem" \{ id, index } -> React.do
  { ref } <- useSortable { id: SortableId id, index, feedback: move }
  pure $ div { ref } id

cloneItem :: { id :: String, index :: Int } -> JSX
cloneItem = component "CloneItem" \{ id, index } -> React.do
  { ref } <- useSortable { id: SortableId id, index, feedback: clone }
  pure $ div { ref } id
```

## Event handlers

```purescript
eventExample :: {} -> JSX
eventExample = component "EventExample" \_ -> React.do
  pure $ dragDropProvider
    { sensors: [ pointerSensorDefault ]
    , plugins: [ feedback ]
    , onDragStart: \event _manager ->
        log "Drag started"
    , onDragOver: \event _manager ->
        pure unit
    , onDragEnd: \event _manager ->
        when (not event.canceled) do
          log "Drag ended"
    }
    [ -- children
    ]
```

## Sensors

```purescript
import React.DndKit.Sensors (pointerSensor, keyboardSensor, distanceConstraint, delayConstraint)

sensorExample :: {} -> JSX
sensorExample = component "SensorExample" \_ -> React.do
  pure $ dragDropProvider
    { sensors:
        [ pointerSensor { activationConstraints: distanceConstraint { value: 5.0 } }
        , keyboardSensor {}
        ]
    }
    [ -- children
    ]
```

## Modifiers

```purescript
import React.DndKit.Modifiers (restrictToVerticalAxis, restrictToWindow, snap)

modifierExample :: {} -> JSX
modifierExample = component "ModifierExample" \_ -> React.do
  pure $ dragDropProvider { modifiers: [ restrictToVerticalAxis, restrictToWindow ] }
    [ -- children
    ]

snappingItem :: {} -> JSX
snappingItem = component "SnappingItem" \_ -> React.do
  { ref } <- useDraggable { id: DraggableId "a", modifiers: [ snap 20.0 ] }
  pure $ div { ref } "Snaps to 20px grid"
```

## Collision detection

```purescript
import React.DndKit.Collision (closestCenter, pointerIntersection)

dropZone :: {} -> JSX
dropZone = component "DropZone" \_ -> React.do
  { ref } <- useDroppable { id: DroppableId "a", collisionDetector: closestCenter }
  pure $ div { ref } "Zone"

sortItem :: { id :: String, index :: Int } -> JSX
sortItem = component "SortItem" \{ id, index } -> React.do
  { ref } <- useSortable { id: SortableId id, index, collisionDetector: pointerIntersection }
  pure $ div { ref } id
```

## Drag overlay

```purescript
import React.DndKit (dragOverlay, dragOverlay_)

overlayExample :: {} -> JSX
overlayExample = component "OverlayExample" \_ -> React.do
  pure $ dragDropProvider_ do
    dragOverlay { className: "overlay" } do
      div {} "I'm floating!"

overlayText :: {} -> JSX
overlayText = component "OverlayText" \_ -> React.do
  pure $ dragDropProvider_ do
    dragOverlay_ "Just text"
```

## Monitoring

```purescript
import React.DndKit.Hooks (useDragDropMonitor, useDragOperation)

monitor :: {} -> JSX
monitor = component "Monitor" \_ -> React.do
  useDragDropMonitor
    { onDragStart: \event _manager -> log "started"
    , onDragEnd: \event _manager -> log "ended"
    }
  op <- useDragOperation
  pure $ div {} $ "canceled: " <> show op.canceled
```

## All config options

```purescript
allDraggableOptions :: {} -> JSX
allDraggableOptions = component "AllDraggable" \_ -> React.do
  { ref } <- useDraggable
    { id: DraggableId "d"            -- required
    , type: DragType "card"
    , disabled: false
    , feedback: clone
    , modifiers: [ restrictToVerticalAxis ]
    , sensors: [ pointerSensorDefault ]
    , data: { tag: "hello" }
    }
  pure $ div { ref } "Draggable"

allDroppableOptions :: {} -> JSX
allDroppableOptions = component "AllDroppable" \_ -> React.do
  { ref } <- useDroppable
    { id: DroppableId "z"            -- required
    , type: DragType "card"
    , disabled: false
    , collisionDetector: closestCenter
    , collisionPriority: 10.0
    , data: { priority: 1 }
    }
  pure $ div { ref } "Droppable"

allSortableOptions :: {} -> JSX
allSortableOptions = component "AllSortable" \_ -> React.do
  { ref } <- useSortable
    { id: SortableId "s"             -- required
    , index: 0                       -- required
    , group: "cards"
    , type: DragType "card"
    , accept: DragType "card"
    , disabled: false
    , feedback: move
    , modifiers: [ restrictToVerticalAxis ]
    , sensors: [ pointerSensorDefault ]
    , collisionDetector: closestCenter
    , collisionPriority: 5.0
    , transition: { duration: 200.0, easing: "ease", idle: true }
    , data: { order: 0 }
    }
  pure $ div { ref } "Sortable"
```

## License

MIT
