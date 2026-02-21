module Test.React.DndKit.Stories.KeyboardNav where

import Prelude hiding (div)

import Data.Array (mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Sensors (keyboardSensorDefault, pointerSensorDefault)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragEndEvent, DragDropManager, callbackRef)
import Test.React.DndKit.Stories.KeyboardNav.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { itemColor :: String
  , activeColor :: String
  }

type Item = { id :: String, label :: String }

keyboardNav :: Props -> JSX
keyboardNav = component "KeyboardNav" \props -> React.do
  items /\ setItems <- React.useState initialItems
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setItems \current -> moveItems current event
  pure $ div { style: Styles.containerStyle } do
    [ div { style: Styles.instructionStyle }
        (text "Tab to focus \x2022 Space to grab \x2022 Arrows to move \x2022 Space to drop \x2022 Esc to cancel")
    , dragDropProvider { onDragEnd, sensors: [ pointerSensorDefault, keyboardSensorDefault ] }
        ( items # mapWithIndex \index item ->
            navItem { id: item.id, label: item.label, index, itemColor: props.itemColor, activeColor: props.activeColor }
        )
    ]
  where
  initialItems = range 1 8 <#> \i ->
    { id: "nav-" <> show i, label: "Item " <> show i }

type NavItemProps =
  { id :: String
  , label :: String
  , index :: Int
  , itemColor :: String
  , activeColor :: String
  }

navItem :: NavItemProps -> JSX
navItem = component "NavItem" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let bg = if result.isDragging then props.activeColor else props.itemColor
  let opacity = if result.isDragging then "0.8" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.itemStyle bg opacity cursor }
      [ span { style: Styles.indexStyle } (text (show (props.index + 1)))
      , text props.label
      ]
