module Test.React.DndKit.Stories.ScrollableContainers where

import Prelude hiding (div)

import Data.Array (length, mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX, keyed)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Hooks (useDroppable)
import React.DndKit.Plugins (accessibility, autoScroller, cursor, feedback, preventSelection)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragDropManager, DragOverEvent, DragType(..), DroppableId(..), callbackRef, clone)
import Test.React.DndKit.Stories.ScrollableContainers.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { columnColor :: String
  , itemColor :: String
  , headerColor :: String
  }

type Item = { id :: String, label :: String }

type Columns =
  { left :: Array Item
  , right :: Array Item
  }

scrollableContainers :: Props -> JSX
scrollableContainers = component "ScrollableContainers" \props -> React.do
  columns /\ setColumns <- React.useState initialColumns
  let
    onDragOver :: DragOverEvent -> DragDropManager -> Effect Unit
    onDragOver event _ = setColumns \cols -> moveItems cols event
    plugins = [ feedback, autoScroller, cursor, accessibility, preventSelection ]
  pure $ div { style: Styles.layoutStyle } do
    dragDropProvider { onDragOver, plugins }
      [ scrollColumn { name: "Left", group: "left", items: columns.left, columnColor: props.columnColor, itemColor: props.itemColor, headerColor: props.headerColor }
      , scrollColumn { name: "Right", group: "right", items: columns.right, columnColor: props.columnColor, itemColor: props.itemColor, headerColor: props.headerColor }
      ]
  where
  initialColumns =
    { left: range 1 20 <#> \i -> { id: "left-" <> show i, label: "Left Item " <> show i }
    , right: range 1 20 <#> \i -> { id: "right-" <> show i, label: "Right Item " <> show i }
    }

type ColumnProps =
  { name :: String
  , group :: String
  , items :: Array Item
  , columnColor :: String
  , itemColor :: String
  , headerColor :: String
  }

scrollColumn :: ColumnProps -> JSX
scrollColumn = component "ScrollColumn" \props -> React.do
  droppable <- useDroppable { id: DroppableId props.group, type: DragType "column", accept: DragType "item", collisionPriority: -1.0 }
  let items = props.items # mapWithIndex \index item ->
        keyed item.id $ scrollItem { id: item.id, label: item.label, index, group: props.group, itemColor: props.itemColor }
  pure $
    div { style: Styles.columnStyle props.columnColor }
      [ div { style: Styles.headerStyle }
          [ span { style: Styles.titleStyle props.headerColor } (text props.name)
          , span { style: Styles.countStyle } (text (show (length props.items)))
          ]
      , div { ref: callbackRef droppable.ref, style: Styles.scrollAreaStyle droppable.isDropTarget } items
      ]

type ItemProps =
  { id :: String
  , label :: String
  , index :: Int
  , group :: String
  , itemColor :: String
  }

scrollItem :: ItemProps -> JSX
scrollItem = component "ScrollItem" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index, group: props.group, type: DragType "item", accept: DragType "item", feedback: clone }
  let opacity = if result.isDragging then "0.4" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.itemStyle props.itemColor opacity cursor }
      [ span { style: Styles.handleStyle } "⠿"
      , text props.label
      ]
