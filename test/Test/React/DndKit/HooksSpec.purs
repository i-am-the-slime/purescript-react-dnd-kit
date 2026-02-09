module Test.React.DndKit.HooksSpec where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Newtype (un)
import Effect.Class (liftEffect)
import React.Basic (element)
import React.Basic.DOM as R
import React.Basic.Hooks (component)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Collision (closestCenter)
import React.DndKit.Hooks (useDragDropMonitor, useDragOperation, useDraggable, useDroppable)
import React.DndKit.Modifiers (restrictToVerticalAxis)
import React.DndKit.Sensors (pointerSensorDefault)
import React.DndKit.Types (DraggableId(..), DroppableId(..))
import React.TestingLibrary (cleanup, render)
import Test.React.DndKit.Utils (rawDiv, refDiv)
import Test.Spec (Spec, after_, describe, it)
import Test.Spec.Assertions.DOM (textContentShouldEqual)

spec :: Spec Unit
spec = after_ cleanup do
  describe "useDraggable" do
    it "config: id, type, disabled, feedback, modifiers, sensors, data" do
      mkDraggableAll <- liftEffect $ component "DraggableAll" \_ -> React.do
        result <- useDraggable
          { id: DraggableId "d-all"
          , type: "item"
          , disabled: false
          , feedback: "clone"
          , modifiers: [ restrictToVerticalAxis ]
          , sensors: [ pointerSensorDefault ]
          , data: { tag: "hello" }
          }
        pure $ element rawDiv
          { ref: result.ref
          , "data-testid": "draggable-all"
          , children:
              [ element rawDiv { ref: result.handleRef, "data-testid": "drag-handle", children: [] }
              ]
          }
      { findByTestId } <- render $ dragDropProvider {} [ mkDraggableAll {} ]
      _ <- findByTestId "draggable-all"
      _ <- findByTestId "drag-handle"
      pure unit

    it "result: ref, handleRef, isDragSource, isDragging, isDropping" do
      mkDraggable <- liftEffect $ component "DraggableResult" \_ -> React.do
        result <- useDraggable { id: DraggableId "d-res" }
        let
          label = "drag:" <> show result.isDragSource
            <> ":"
            <> show result.isDragging
            <> ":"
            <> show result.isDropping
        pure $ refDiv result.ref "drag-res" [ R.text label ]
      { findByText } <- render $ dragDropProvider {} [ mkDraggable {} ]
      result <- findByText "drag:false:false:false"
      result `textContentShouldEqual` "drag:false:false:false"

  describe "useDroppable" do
    it "config: id, disabled, type, collisionDetector, collisionPriority, data" do
      mkDroppableAll <- liftEffect $ component "DroppableAll" \_ -> React.do
        result <- useDroppable
          { id: DroppableId "z-all"
          , disabled: false
          , type: "zone"
          , collisionDetector: closestCenter
          , collisionPriority: 10.0
          , data: { priority: 1 }
          }
        pure $ element rawDiv
          { ref: result.ref
          , "data-testid": "droppable-all"
          , children: []
          }
      { findByTestId } <- render $ dragDropProvider {} [ mkDroppableAll {} ]
      _ <- findByTestId "droppable-all"
      pure unit

    it "result: ref, isDropTarget" do
      mkDroppable <- liftEffect $ component "DroppableResult" \_ -> React.do
        result <- useDroppable { id: DroppableId "z-res" }
        let label = "drop:" <> show result.isDropTarget
        pure $ refDiv result.ref "drop-res" [ R.text label ]
      { findByText } <- render $ dragDropProvider {} [ mkDroppable {} ]
      result <- findByText "drop:false"
      result `textContentShouldEqual` "drop:false"

  describe "useDragDropMonitor" do
    it "config: onBeforeDragStart, onDragStart, onDragMove, onDragOver, onCollision, onDragEnd" do
      mkMonitor <- liftEffect $ component "MonitorAll" \{ children } -> React.do
        useDragDropMonitor
          { onBeforeDragStart: \_ _ -> pure unit
          , onDragStart: \_ _ -> pure unit
          , onDragMove: \_ _ -> pure unit
          , onDragOver: \_ _ -> pure unit
          , onCollision: \_ _ -> pure unit
          , onDragEnd: \_ _ -> pure unit
          }
        pure $ R.div_ children
      { findByText } <- render $ dragDropProvider {} [ mkMonitor { children: [ R.text "Monitored" ] } ]
      result <- findByText "Monitored"
      result `textContentShouldEqual` "Monitored"

  describe "useDragOperation" do
    it "result: source, target, activatorEvent, canceled, transform, position" do
      mkOpViewer <- liftEffect $ component "OpViewer" \_ -> React.do
        op <- useDragOperation
        let
          srcLabel = case op.source of
            Nothing -> "src:none"
            Just s -> "src:" <> un DraggableId s.id
        let
          tgtLabel = case op.target of
            Nothing -> "tgt:none"
            Just t -> "tgt:" <> un DroppableId t.id
        let
          evtLabel = case op.activatorEvent of
            Nothing -> "evt:none"
            Just _ -> "evt:yes"
        let
          label = srcLabel <> "|" <> tgtLabel <> "|" <> evtLabel
            <> "|canceled:"
            <> show op.canceled
            <> "|tx:"
            <> show op.transform.x
            <> "|ty:"
            <> show op.transform.y
            <> "|cx:"
            <> show op.position.current.x
            <> "|cy:"
            <> show op.position.current.y
            <> "|ix:"
            <> show op.position.initial.x
            <> "|iy:"
            <> show op.position.initial.y
        pure $ element rawDiv { "data-testid": "op-viewer", children: [ R.text label ] }
      { findByText } <- render $ dragDropProvider {} [ mkOpViewer {} ]
      result <- findByText "src:none|tgt:none|evt:none|canceled:false|tx:0.0|ty:0.0|cx:0.0|cy:0.0|ix:0.0|iy:0.0"
      result `textContentShouldEqual` "src:none|tgt:none|evt:none|canceled:false|tx:0.0|ty:0.0|cx:0.0|cy:0.0|ix:0.0|iy:0.0"
