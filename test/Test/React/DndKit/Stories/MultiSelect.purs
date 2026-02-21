module Test.React.DndKit.Stories.MultiSelect where

import Prelude hiding (div)

import Data.Array (filter, findIndex, index, length, range, (..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Newtype (un)
import Data.Set as Set
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.DOM.Events (metaKey, shiftKey)
import React.Basic.Events (handler, merge)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider, dragOverlay_)
import React.DndKit.Hooks (useDragOperation, useDraggable, useDroppable)
import React.DndKit.Types (DragDropManager, DragEndEvent, DragType(..), DraggableId(..), DroppableId(..), callbackRef, clone)
import Test.React.DndKit.Stories.MultiSelect.Styles as Styles
import Yoga.React (component)
import Yoga.React.DOM.HTML (div, span)
import Yoga.React.DOM.Internal (text)

type Props =
  { selectedColor :: String
  , targetColor :: String
  , itemCount :: Int
  , gridColumns :: Int
  }

type Item = { id :: String, label :: String }

multiSelect :: Props -> JSX
multiSelect = component "MultiSelect" \props -> React.do
  let initialItems = range 1 props.itemCount <#> \i -> { id: "item-" <> show i, label: "Item " <> show i }
  source /\ setSource <- React.useState initialItems
  target /\ setTarget <- React.useState ([] :: Array Item)
  selected /\ setSelected <- React.useState (Set.empty :: Set.Set String)
  lastClicked /\ setLastClicked <- React.useState (Nothing :: Maybe String)
  let
    handleClick id mods = do
      let isShift = fromMaybe false mods.shiftKey
      let isMeta = fromMaybe false mods.metaKey
      if isMeta then do
        setSelected \s -> if Set.member id s then Set.delete id s else Set.insert id s
        setLastClicked \_ -> Just id
      else if isShift then do
        case lastClicked of
          Nothing -> do
            setSelected \_ -> Set.singleton id
            setLastClicked \_ -> Just id
          Just last -> do
            let fromIdx = fromMaybe 0 (findIndex (\i -> i.id == last) source)
            let toIdx = fromMaybe 0 (findIndex (\i -> i.id == id) source)
            let lo = min fromIdx toIdx
            let hi = max fromIdx toIdx
            let ids = (lo .. hi) <#> \idx -> index source idx # fromMaybe { id: "", label: "" } # _.id
            setSelected \_ -> Set.fromFoldable ids
      else do
        setSelected \_ -> Set.singleton id
        setLastClicked \_ -> Just id

    onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
    onDragEnd event _ = case event.operation.target of
      Just t | un DroppableId t.id == "target-zone" ->
        case event.operation.source of
          Just s -> do
            let draggedId = un DraggableId s.id
            let sel = if Set.member draggedId selected then selected else Set.singleton draggedId
            let movedItems = source # filter \i -> Set.member i.id sel
            setSource \src -> src # filter \i -> not (Set.member i.id sel)
            setTarget \tgt -> tgt <> movedItems
            setSelected \_ -> Set.empty
          Nothing -> pure unit
      _ -> pure unit

  pure $ div { style: Styles.layoutStyle } do
    dragDropProvider { onDragEnd }
      [ div { style: Styles.sectionStyle }
          [ div { style: Styles.labelStyle } (text "Source")
          , div { style: Styles.gridStyle props.gridColumns }
              ( source <#> \item ->
                  selectableItem
                    { id: item.id
                    , label: item.label
                    , isSelected: Set.member item.id selected
                    , onClick: handleClick item.id
                    , selectedColor: props.selectedColor
                    }
              )
          ]
      , dropTarget { items: target, targetColor: props.targetColor }
      , selectionOverlay { source, selected, selectedColor: props.selectedColor }
      ]

type SelectableItemProps =
  { id :: String
  , label :: String
  , isSelected :: Boolean
  , onClick :: { shiftKey :: Maybe Boolean, metaKey :: Maybe Boolean } -> Effect Unit
  , selectedColor :: String
  }

selectableItem :: SelectableItemProps -> JSX
selectableItem = component "SelectableItem" \props -> React.do
  result <- useDraggable { id: DraggableId props.id, type: DragType "item", feedback: clone }
  let bg = if props.isSelected then props.selectedColor else "#334155"
  let opacity = if result.isDragging then "0.4" else "1"
  pure $
    div
      { ref: callbackRef result.ref
      , style: Styles.itemStyle bg opacity
      , onClick: handler (merge { shiftKey, metaKey }) props.onClick
      }
      [ span { style: Styles.checkStyle } (text (if props.isSelected then "✓" else ""))
      , text props.label
      ]

type DropTargetProps =
  { items :: Array Item
  , targetColor :: String
  }

dropTarget :: DropTargetProps -> JSX
dropTarget = component "DropTarget" \props -> React.do
  result <- useDroppable { id: DroppableId "target-zone", accept: DragType "item" }
  let bg = if result.isDropTarget then props.targetColor else "#1e293b"
  let border = if result.isDropTarget then "2px solid " <> props.targetColor else "2px dashed #475569"
  pure $
    div { style: Styles.sectionStyle }
      [ div { style: Styles.labelStyle } (text "Target")
      , div { ref: callbackRef result.ref, style: Styles.targetStyle bg border }
          ( if length props.items == 0
            then [ div { style: Styles.emptyStyle } (text "Drop items here") ]
            else props.items <#> \item ->
              div { style: Styles.targetItemStyle } (text item.label)
          )
      ]

type OverlayProps =
  { source :: Array Item
  , selected :: Set.Set String
  , selectedColor :: String
  }

selectionOverlay :: OverlayProps -> JSX
selectionOverlay = component "SelectionOverlay" \props -> React.do
  op <- useDragOperation
  let activeId = op.source <#> \s -> un DraggableId s.id
  pure $ case activeId of
    Just dragId -> do
      let count = if Set.member dragId props.selected then Set.size props.selected else 1
      dragOverlay_ $
        div { style: Styles.overlayStyle props.selectedColor }
          [ text (if count == 1 then "1 item" else show count <> " items")
          , if count > 1
            then span { style: Styles.badgeStyle } (text (show count))
            else text ""
          ]
    Nothing -> dragOverlay_ ""
