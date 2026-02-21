module Test.React.DndKit.Stories.GridSnap where

import Prelude hiding (div)

import Data.Array (mapWithIndex, range)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic (JSX, keyed)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Helpers (moveItems)
import React.DndKit.Modifiers (restrictToWindow, snap)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.DndKit.Types (DragEndEvent, DragDropManager, callbackRef)
import Test.React.DndKit.Stories.GridSnap.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)
import Yoga.React.DOM.Internal (text)

type Props =
  { tileColor :: String
  , accentColor :: String
  }

type Tile = { id :: String, label :: String }

gridSnap :: Props -> JSX
gridSnap = component "GridSnap" \props -> React.do
  items /\ setItems <- React.useState initialTiles
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = setItems \current -> moveItems current event
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd, modifiers: [ snapMod, restrictToWindow ] }
      ( items # mapWithIndex \index item ->
          keyed item.id $ tile { id: item.id, label: item.label, index, tileColor: props.tileColor, accentColor: props.accentColor }
      )
  where
  snapMod = unsafePerformEffect $ snap { x: 116.0, y: 116.0 }
  initialTiles = range 1 9 <#> \i ->
    { id: "tile-" <> show i, label: show i }

type TileProps =
  { id :: String
  , label :: String
  , index :: Int
  , tileColor :: String
  , accentColor :: String
  }

tile :: TileProps -> JSX
tile = component "Tile" \props -> React.do
  result <- useSortable { id: SortableId props.id, index: props.index }
  let opacity = if result.isDragging then "0.4" else "1"
  let cursor = if result.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef result.ref, style: Styles.tileStyle props.tileColor props.accentColor opacity cursor }
      (text props.label)
