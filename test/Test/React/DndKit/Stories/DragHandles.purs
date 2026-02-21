module Test.React.DndKit.Stories.DragHandles where

import Prelude hiding (div)

import Data.Array (mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Console (log)
import React.Basic (JSX, keyed)
import React.Basic.Events (handler_)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Modifiers (restrictToHorizontalAxis, restrictToVerticalAxis)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragDropManager, DragEndEvent, Modifier, callbackRef)
import Test.React.DndKit.Stories.DragHandles.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (button, div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { itemCount :: Int
  , lockAxis :: String
  }

dragHandles :: Props -> JSX
dragHandles = component "DragHandles" \props -> React.do
  let initialItems = range 1 props.itemCount <#> \i ->
        { id: "item-" <> show i
        , title: "Task " <> show i
        , description: "Description for task " <> show i
        }
  let modifiers = axisModifier props.lockAxis
  items /\ setItems <- React.useState initialItems
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setItems \current -> moveItems current event
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd, modifiers } do
      items # mapWithIndex \index item ->
        keyed item.id $ handleCard
          { id: item.id
          , title: item.title
          , description: item.description
          , index
          }

axisModifier :: String -> Array Modifier
axisModifier = case _ of
  "vertical" -> [ restrictToVerticalAxis ]
  "horizontal" -> [ restrictToHorizontalAxis ]
  _ -> []

type CardProps =
  { id :: String
  , title :: String
  , description :: String
  , index :: Int
  }

handleCard :: CardProps -> JSX
handleCard = component "HandleCard" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let bg = if result.isDragging then "rgba(255,255,255,0.1)" else "#334155"
  let opacity = if result.isDragging then "0.8" else "1"
  pure $
    div { ref: callbackRef result.ref, style: Styles.cardStyle bg opacity }
      [ span { ref: callbackRef result.handleRef, style: Styles.gripStyle } "⠿"
      , div { style: Styles.contentStyle }
          [ div { style: Styles.titleStyle } (text props.title)
          , div { style: Styles.descriptionStyle } (text props.description)
          ]
      , button
          { style: Styles.buttonStyle
          , onClick: handler_ (log ("Clicked: " <> props.title))
          }
          (text "Action")
      ]
