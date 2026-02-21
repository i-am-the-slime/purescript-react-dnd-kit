module Test.React.DndKit.Stories.DragToTrash where

import Prelude hiding (div)

import Data.Array (filter, range)
import Data.Maybe (Maybe(..), isJust)
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX, keyed)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDragOperation, useDraggable, useDroppable)
import React.DndKit.Plugins (configureFeedback, noDropAnimation)
import React.DndKit.Types (DragEndEvent, DragDropManager, DraggableId(..), DroppableId(..), callbackRef)
import Test.React.DndKit.Stories.DragToTrash.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)

type Props =
  { cardColor :: String
  , trashColor :: String
  , itemCount :: Int
  }

dragToTrash :: Props -> JSX
dragToTrash = component "DragToTrash" \props -> React.do
  let initialItems = range 1 props.itemCount <#> \i -> { id: "card-" <> show i, label: "Card " <> show i }
  items /\ setItems <- React.useState initialItems
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = case event.operation.target of
      Just t | un DroppableId t.id == "trash" ->
        case event.operation.source of
          Just s -> setItems (filter \item -> item.id /= un DraggableId s.id)
          Nothing -> pure unit
      _ -> pure unit
    plugins = [ configureFeedback { dropAnimation: noDropAnimation } ]
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd, plugins }
      [ div { style: Styles.gridStyle }
          ( items <#> \item ->
              keyed item.id $ draggableCard { id: item.id, label: item.label, cardColor: props.cardColor }
          )
      , trashZone { trashColor: props.trashColor }
      ]

type CardProps =
  { id :: String
  , label :: String
  , cardColor :: String
  }

draggableCard :: CardProps -> JSX
draggableCard = component "DraggableCard" \props -> React.do
  result <- useDraggable { id: DraggableId props.id }
  let opacity = if result.isDragging then "0.4" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cardStyle props.cardColor opacity cursor }
      props.label

type TrashProps = { trashColor :: String }

trashZone :: TrashProps -> JSX
trashZone = component "TrashZone" \props -> React.do
  result <- useDroppable { id: DroppableId "trash" }
  op <- useDragOperation
  let isActive = isJust op.source
  let bg = if result.isDropTarget then props.trashColor else "#374151"
  let border = if isActive then "2px dashed " <> props.trashColor else "2px dashed #4b5563"
  let scale = if result.isDropTarget then "1.05" else "1"
  pure $
    div { ref: callbackRef result.ref, style: Styles.zoneStyle bg border scale isActive }
      (if result.isDropTarget then "Release to delete" else "Drop here to delete")
