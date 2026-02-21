module Test.React.DndKit.Stories.DragOverlayDemo where

import Prelude hiding (div)

import Data.Array (find, mapWithIndex, range)
import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider, dragOverlay_)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Hooks (useDragOperation)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragDropManager, DragEndEvent, DraggableId(..), callbackRef)
import Test.React.DndKit.Stories.DragOverlayDemo.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { itemColor :: String
  , overlayColor :: String
  }

type Item = { id :: String, label :: String }

dragOverlayDemo :: Props -> JSX
dragOverlayDemo = component "DragOverlayDemo" \props -> React.do
  items /\ setItems <- React.useState initialItems
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setItems \current -> moveItems current event
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd }
      [ div { style: Styles.listStyle }
          ( items # mapWithIndex \index item ->
              overlayItem { id: item.id, label: item.label, index, itemColor: props.itemColor }
          )
      , activeOverlay { items, overlayColor: props.overlayColor }
      ]
  where
  initialItems = range 1 6 <#> \i ->
    { id: "item-" <> show i, label: "Item " <> show i }

type OverlayItemProps =
  { id :: String
  , label :: String
  , index :: Int
  , itemColor :: String
  }

overlayItem :: OverlayItemProps -> JSX
overlayItem = component "OverlayItem" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let opacity = if result.isDragging then "0.3" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.itemStyle props.itemColor opacity cursor }
      [ span { style: Styles.handleStyle } "⠿"
      , text props.label
      ]

type ActiveOverlayProps =
  { items :: Array Item
  , overlayColor :: String
  }

activeOverlay :: ActiveOverlayProps -> JSX
activeOverlay = component "ActiveOverlay" \props -> React.do
  op <- useDragOperation
  let activeItem = op.source >>= \s -> find (\item -> item.id == un DraggableId s.id) props.items
  pure $ case activeItem of
    Just item ->
      dragOverlay_
        ( div { style: Styles.overlayStyle props.overlayColor }
            [ span { style: Styles.overlayHandleStyle } "⠿"
            , text item.label
            ]
        )
    Nothing -> dragOverlay_ ""
