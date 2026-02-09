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

## Example

```purescript
module Example where

import Prelude

import Data.Array (findIndex, mapWithIndex)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Console (log)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider, dragOverlay)
import React.DndKit.Collision (closestCenter)
import React.DndKit.Helpers (arrayMove)
import React.DndKit.Hooks (useDragDropMonitor, useDragOperation, useDraggable, useDroppable)
import React.DndKit.Modifiers (restrictToVerticalAxis)
import React.DndKit.Plugins (feedback, preventSelection)
import React.DndKit.Sensors (pointerSensor, distanceConstraint)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragType(..), DraggableId(..), DroppableId(..), move)
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span, p, button)

-- Sortable list with reordering

sortableDemo :: {} -> JSX
sortableDemo = component "SortableDemo" \_ -> React.do
  items /\ setItems <- React.useState [ "Apples", "Bananas", "Oranges", "Mangoes" ]
  let
    reorder event _ = do
      let src = event.operation.source >>= \s -> findIndex (_ == un DraggableId s.id) items
      let tgt = event.operation.target >>= \t -> findIndex (_ == un DroppableId t.id) items
      case src, tgt of
        Just from, Just to -> setItems \_ -> arrayMove items from to
        _, _ -> pure unit
  pure $ dragDropProvider
    { sensors: [ pointerSensor { activationConstraints: distanceConstraint { value: 5.0 } } ]
    , plugins: [ feedback, preventSelection ]
    , modifiers: [ restrictToVerticalAxis ]
    , onDragOver: reorder
    , onDragEnd: \event _ ->
        when (not event.canceled) do
          log "Reorder complete"
    }
    ( items # mapWithIndex \index item ->
        sortableItem { id: item, index }
    )

sortableItem :: { id :: String, index :: Int } -> JSX
sortableItem = component "SortableItem" \{ id, index } -> React.do
  { ref, handleRef, isDragSource } <- useSortable
    { id: SortableId id
    , index
    , feedback: move
    , collisionDetector: closestCenter
    }
  pure $ div { ref, className: "sortable-item" } do
    span {} id
    button { ref: handleRef } "drag"

-- Drag and drop with type matching

dragDropDemo :: {} -> JSX
dragDropDemo = component "DragDropDemo" \_ -> React.do
  pure $ dragDropProvider
    { sensors: [ pointerSensor {} ]
    , plugins: [ feedback ]
    }
    [ card {}
    , cardZone {}
    , dragOverlay {} "Dragging..."
    ]

card :: {} -> JSX
card = component "Card" \_ -> React.do
  { ref, handleRef, isDragSource } <- useDraggable
    { id: DraggableId "card-1"
    , type: DragType "card"
    , data: { label: "My card" }
    }
  pure $ div { ref, className: if isDragSource then "dragging" else "card" } do
    button { ref: handleRef } "Grab"

cardZone :: {} -> JSX
cardZone = component "CardZone" \_ -> React.do
  { ref, isDropTarget } <- useDroppable
    { id: DroppableId "zone-1"
    , type: DragType "card"
    , collisionDetector: closestCenter
    }
  pure $ div { ref, className: if isDropTarget then "zone active" else "zone" } do
    p {} "Drop cards here"

-- Monitor drag state from any nested component

dragStatus :: {} -> JSX
dragStatus = component "DragStatus" \_ -> React.do
  useDragDropMonitor
    { onDragStart: \_ _ -> log "drag start"
    , onDragEnd: \_ _ -> log "drag end"
    }
  op <- useDragOperation
  pure $ div {} case op.source of
    Nothing -> "Idle"
    Just src -> "Dragging: " <> un DraggableId src.id
```

## All config options

```purescript
useDraggable
  { id: DraggableId "d"            -- required
  , type: DragType "card"
  , disabled: false
  , feedback: clone
  , modifiers: [ restrictToVerticalAxis ]
  , sensors: [ pointerSensorDefault ]
  , data: { tag: "hello" }
  }

useDroppable
  { id: DroppableId "z"            -- required
  , type: DragType "card"
  , disabled: false
  , collisionDetector: closestCenter
  , collisionPriority: 10.0
  , data: { priority: 1 }
  }

useSortable
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

dragDropProvider
  { manager: myManager
  , sensors: [ pointerSensorDefault ]
  , plugins: [ feedback, preventSelection ]
  , modifiers: [ restrictToVerticalAxis ]
  , onBeforeDragStart: \event manager -> pure unit
  , onDragStart: \event manager -> pure unit
  , onDragMove: \event manager -> pure unit
  , onDragOver: \event manager -> pure unit
  , onCollision: \event manager -> pure unit
  , onDragEnd: \event manager -> pure unit
  }
  children
```

## License

MIT
