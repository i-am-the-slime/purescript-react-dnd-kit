module Test.React.DndKit.Stories.ScrollableContainers where

import Prelude hiding (div)

import Data.Array (length, mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX, keyed)
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Hooks (useDroppable)
import React.DndKit.Plugins (accessibility, autoScroller, cursor, feedback, preventSelection)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragDropManager, DragOverEvent, DragType(..), DroppableId(..), FeedbackType, callbackRef, clone, move)
import Test.React.DndKit.Stories.ScrollableContainers.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (button, div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { itemsPerColumn :: Int
  , containerHeight :: Int
  , feedback :: String
  , reset :: Boolean
  }

type Item = { id :: String, label :: String }

type Columns =
  { left :: Array Item
  , right :: Array Item
  }

scrollableContainers :: Props -> JSX
scrollableContainers = component "ScrollableContainers" \props -> React.do
  let makeCols n =
        { left: range 1 n <#> \i -> { id: "left-" <> show i, label: "Left Item " <> show i }
        , right: range 1 n <#> \i -> { id: "right-" <> show i, label: "Right Item " <> show i }
        }
  columns /\ setColumns <- React.useState (makeCols props.itemsPerColumn)
  React.useEffect props.itemsPerColumn do
    setColumns \_ -> makeCols props.itemsPerColumn
    pure (pure unit)
  let
    onDragOver :: DragOverEvent -> DragDropManager -> Effect Unit
    onDragOver event _ = setColumns \cols -> moveItems cols event
    plugins = [ feedback, autoScroller, cursor, accessibility, preventSelection ]
  let reset = setColumns \_ -> makeCols props.itemsPerColumn
  pure $ div {}
    [ div { style: Styles.layoutStyle } do
        dragDropProvider { onDragOver, plugins }
          [ scrollColumn { name: "Left", group: "left", items: columns.left, containerHeight: props.containerHeight, feedback: props.feedback }
          , scrollColumn { name: "Right", group: "right", items: columns.right, containerHeight: props.containerHeight, feedback: props.feedback }
          ]
    , button { style: Styles.resetStyle, onClick: handler_ reset } (text "Reset")
    ]

type ColumnProps =
  { name :: String
  , group :: String
  , items :: Array Item
  , containerHeight :: Int
  , feedback :: String
  }

scrollColumn :: ColumnProps -> JSX
scrollColumn = component "ScrollColumn" \props -> React.do
  droppable <- useDroppable { id: DroppableId props.group, type: DragType "column", accept: DragType "item", collisionPriority: -1.0 }
  let items = props.items # mapWithIndex \index item ->
        keyed item.id $ scrollItem { id: item.id, label: item.label, index, group: props.group, feedback: props.feedback }
  pure $
    div { style: Styles.columnStyle }
      [ div { style: Styles.headerStyle }
          [ span { style: Styles.titleStyle } (text props.name)
          , span { style: Styles.countStyle } (text (show (length props.items)))
          ]
      , div { ref: callbackRef droppable.ref, style: Styles.scrollAreaStyle droppable.isDropTarget props.containerHeight } items
      ]

type ItemProps =
  { id :: String
  , label :: String
  , index :: Int
  , group :: String
  , feedback :: String
  }

scrollItem :: ItemProps -> JSX
scrollItem = component "ScrollItem" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index, group: props.group, type: DragType "item", accept: DragType "item", feedback: parseFeedback props.feedback }
  let opacity = if result.isDragging then "0.4" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.itemStyle opacity cursor }
      [ span { style: Styles.handleStyle } "⠿"
      , text props.label
      ]

parseFeedback :: String -> FeedbackType
parseFeedback = case _ of
  "move" -> move
  _ -> clone
