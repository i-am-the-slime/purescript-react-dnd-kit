module Test.React.DndKit.SortableSpec where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Class (liftEffect)
import React.Basic (element)
import React.Basic.DOM as R
import React.Basic.Hooks (component)
import React.Basic.Hooks as React
import React.DndKit (dragDropProvider)
import React.DndKit.Collision (closestCenter)
import React.DndKit.Modifiers (restrictToVerticalAxis)
import React.DndKit.Sensors (pointerSensorDefault)
import React.DndKit.Sortable (SortableId(..), useSortable)
import React.TestingLibrary (cleanup, render)
import Test.React.DndKit.Utils (rawDiv, refDiv)
import Test.Spec (Spec, after_, describe, it)
import Test.Spec.Assertions.DOM (textContentShouldEqual)

spec :: Spec Unit
spec = after_ cleanup do
  describe "useSortable" do
    it "config: id, index, group, type, accept, disabled, feedback, modifiers, sensors, collisionDetector, collisionPriority, transition, data" do
      mkSortableAll <- liftEffect $ component "SortableAll" \_ -> React.do
        result <- useSortable
          { id: SortableId "s-all"
          , index: 0
          , group: "cards"
          , type: "card"
          , accept: "card"
          , disabled: false
          , feedback: "move"
          , modifiers: [ restrictToVerticalAxis ]
          , sensors: [ pointerSensorDefault ]
          , collisionDetector: closestCenter
          , collisionPriority: 5.0
          , transition: { duration: 200.0, easing: "ease", idle: true }
          , data: { order: 0 }
          }
        pure $ element rawDiv
          { ref: result.ref
          , "data-testid": "sortable-all"
          , children:
              [ element rawDiv { ref: result.handleRef, "data-testid": "sort-handle", children: [] }
              , element rawDiv { ref: result.sourceRef, "data-testid": "sort-source", children: [] }
              , element rawDiv { ref: result.targetRef, "data-testid": "sort-target", children: [] }
              ]
          }
      { findByTestId } <- render $ dragDropProvider
        { children: [ mkSortableAll {} ] }
      _ <- findByTestId "sortable-all"
      _ <- findByTestId "sort-handle"
      _ <- findByTestId "sort-source"
      _ <- findByTestId "sort-target"
      pure unit

    it "result: ref, handleRef, sourceRef, targetRef, isDropTarget, isDragSource, isDragging, isDropping" do
      mkSortable <- liftEffect $ component "SortableResult" \_ -> React.do
        result <- useSortable { id: SortableId "s-res", index: 0 }
        let
          label = "sort:" <> show result.isDropTarget
            <> ":"
            <> show result.isDragSource
            <> ":"
            <> show result.isDragging
            <> ":"
            <> show result.isDropping
        pure $ refDiv result.ref "sort-res" [ R.text label ]
      { findByText } <- render $ dragDropProvider
        { children: [ mkSortable {} ] }
      result <- findByText "sort:false:false:false:false"
      result `textContentShouldEqual` "sort:false:false:false:false"

    it "renders multiple sortable items" do
      let items = [ "a" /\ 0, "b" /\ 1, "c" /\ 2 ]
      mkItem <- liftEffect $ component "SI" \{ id, index } -> React.do
        { ref } <- useSortable { id: SortableId id, index }
        pure $ refDiv ref ("si-" <> id) [ R.text $ "Item " <> id ]
      { findByTestId } <- render $ dragDropProvider
        { children: items <#> \(id /\ index) -> mkItem { id, index } }
      _ <- findByTestId "si-a"
      _ <- findByTestId "si-b"
      _ <- findByTestId "si-c"
      pure unit
