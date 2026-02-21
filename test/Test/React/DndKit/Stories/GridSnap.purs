module Test.React.DndKit.Stories.GridSnap where

import Prelude hiding (div)

import Data.Array (findIndex, index, mapWithIndex, range, updateAt)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (un)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import React.Basic (JSX, keyed)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Hooks (useDraggable, useDroppable)
import React.DndKit.Modifiers (restrictToWindow, snap)
import React.DndKit.Types (DragDropManager, DragEndEvent, DraggableId(..), DroppableId(..), callbackRef, clone)
import Test.React.DndKit.Stories.GridSnap.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div)
import Yoga.React.DOM.Internal (text)

type Props =
  { tileColor :: String
  , accentColor :: String
  }

type Tile = { id :: String, label :: String, slot :: String }

gridSnap :: Props -> JSX
gridSnap = component "GridSnap" \props -> React.do
  tiles /\ setTiles <- React.useState initialTiles
  let
    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = case event.operation.source /\ event.operation.target of
      Just s /\ Just t -> setTiles \ts -> swapTiles (un DraggableId s.id) (un DroppableId t.id) ts
      _ -> pure unit
  pure $ div { style: Styles.containerStyle } do
    dragDropProvider { onDragEnd, modifiers: [ snapMod, restrictToWindow ] }
      ( tiles # mapWithIndex \_ t ->
          keyed t.slot $ gridCell
            { slot: t.slot
            , tileId: t.id
            , label: t.label
            , tileColor: props.tileColor
            , accentColor: props.accentColor
            }
      )
  where
  snapMod = unsafePerformEffect $ snap { x: 116.0, y: 116.0 }
  initialTiles = range 1 9 <#> \i ->
    { id: "tile-" <> show i, label: show i, slot: "slot-" <> show i }

swapTiles :: String -> String -> Array Tile -> Array Tile
swapTiles srcId tgtSlot ts = fromMaybe ts do
  si <- findIndex (\t -> t.id == srcId) ts
  ti <- findIndex (\t -> t.slot == tgtSlot) ts
  s <- index ts si
  t <- index ts ti
  ts' <- updateAt si (s { slot = t.slot }) ts
  updateAt ti (t { slot = s.slot }) ts'

type CellProps =
  { slot :: String
  , tileId :: String
  , label :: String
  , tileColor :: String
  , accentColor :: String
  }

gridCell :: CellProps -> JSX
gridCell = component "GridCell" \props -> React.do
  droppable <- useDroppable { id: DroppableId props.slot }
  draggable <- useDraggable { id: DraggableId props.tileId, feedback: clone }
  let opacity = if draggable.isDragging then "0.4" else "1"
  let cursor = if draggable.isDragging then "grabbing" else "grab"
  pure $
    div { ref: callbackRef droppable.ref }
      [ div { ref: callbackRef draggable.ref, style: Styles.tileStyle props.tileColor props.accentColor opacity cursor }
          (text props.label)
      ]
