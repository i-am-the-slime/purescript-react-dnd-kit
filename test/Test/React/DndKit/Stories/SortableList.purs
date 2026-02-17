module Test.React.DndKit.Stories.SortableList where

import Prelude hiding (div)

import Data.Array (mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragEndEvent, DragDropManager, callbackRef)
import Test.React.DndKit.Stories.SortableList.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { itemColor :: String
  , dragColor :: String
  , itemCount :: Int
  }

sortableList :: Props -> JSX
sortableList = component "SortableList" \props -> React.do
  let initialItems = makeItems props.itemCount
  items /\ setItems <- React.useState initialItems
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setItems \current -> moveItems current event
  pure
    $ div { style: Styles.containerStyle } do
        dragDropProvider { onDragEnd } do
          items # mapWithIndex \index item ->
            sortableItem
              { id: item.id
              , label: item.label
              , index
              , itemColor: props.itemColor
              , dragColor: props.dragColor
              }
  where
  makeItems n = range 1 n <#> \i ->
    { id: "item-" <> show i, label: "Item " <> show i }

type ItemProps =
  { id :: String
  , label :: String
  , index :: Int
  , itemColor :: String
  , dragColor :: String
  }

sortableItem :: ItemProps -> JSX
sortableItem = component "SortableItem" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let bg = if result.isDragging then props.dragColor else props.itemColor
  let opacity = if result.isDragging then "0.8" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.itemStyle bg opacity cursor }
      [ span { style: Styles.handleStyle } "⠿"
      , text props.label
      ]
