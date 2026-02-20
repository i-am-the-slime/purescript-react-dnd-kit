module Test.React.DndKit.Spec where

import Prelude

import Data.Tuple.Nested ((/\))
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Foreign (unsafeToForeign)
import React.Basic.DOM as R
import React.DndKit (dragDropProvider, dragOverlay)
import React.DndKit.Modifiers (restrictToHorizontalAxis, restrictToVerticalAxis, restrictToWindow, snap)
import React.DndKit.Plugins (accessibility, autoScroller, cursor, feedback, preventSelection)
import React.DndKit.Sensors (delayConstraint, distanceConstraint, keyboardSensor, keyboardSensorDefault, pointerSensor, pointerSensorDefault)
import React.TestingLibrary (cleanup, render)
import Test.React.DndKit.Stories.Kanban (kanban)
import Test.Spec (Spec, after_, describe, it)
import Test.Spec.Assertions.DOM (textContentShouldEqual)

spec :: Spec Unit
spec = after_ cleanup do
  describe "dragDropProvider" do
    it "children" do
      { findByText } <- render $ dragDropProvider {} [ R.text "Hello" ]
      result <- findByText "Hello"
      result `textContentShouldEqual` "Hello"

    it "sensors (default)" do
      { findByText } <- render $ dragDropProvider
        { sensors: [ pointerSensorDefault, keyboardSensorDefault ] }
        [ R.text "s" ]
      _ <- findByText "s"
      pure unit

    it "sensors (configured)" do
      ps /\ ks <- configuredSensors
      { findByText } <- render $ dragDropProvider
        { sensors: [ ps, ks ] }
        [ R.text "sc" ]
      _ <- findByText "sc"
      pure unit

    it "plugins" do
      { findByText } <- render $ dragDropProvider
        { plugins: [ accessibility, autoScroller, cursor, feedback, preventSelection ] }
        [ R.text "p" ]
      _ <- findByText "p"
      pure unit

    it "modifiers" do
      snapMod <- liftEffect $ snap { x: 20.0, y: 20.0 }
      { findByText } <- render $ dragDropProvider
        { modifiers: [ restrictToVerticalAxis, restrictToHorizontalAxis, restrictToWindow, snapMod ] }
        [ R.text "m" ]
      _ <- findByText "m"
      pure unit

    it "onBeforeDragStart, onDragStart, onDragMove, onDragOver, onCollision, onDragEnd" do
      { findByText } <- render $ dragDropProvider
        { onBeforeDragStart: \_ _ -> pure unit
        , onDragStart: \_ _ -> pure unit
        , onDragMove: \_ _ -> pure unit
        , onDragOver: \_ _ -> pure unit
        , onCollision: \_ _ -> pure unit
        , onDragEnd: \_ _ -> pure unit
        }
        [ R.text "events" ]
      _ <- findByText "events"
      pure unit

  describe "kanban with moveOnDrag" do
    it "renders cards" do
      { findByText } <- render $ kanban { columnColor: "#1e293b", cardColor: "#334155", headerColor: "#fff" }
      result <- findByText "Design mockups"
      result `textContentShouldEqual` "Design mockups"

  describe "dragOverlay" do
    it "children, className, style, tag, disabled" do
      { findByText } <- render $ dragDropProvider {}
        [ R.text "Beside overlay"
        , dragOverlay
            { className: "my-overlay"
            , style: unsafeToForeign { opacity: 0.5 }
            , tag: "section"
            , disabled: false
            }
            [ R.text "Overlay content" ]
        ]
      result <- findByText "Beside overlay"
      result `textContentShouldEqual` "Beside overlay"
  where
  configuredSensors :: Aff _
  configuredSensors = liftEffect do
    dc <- distanceConstraint { value: 10.0, tolerance: 5.0 }
    dl <- delayConstraint { value: 200.0, tolerance: 5.0 }
    ps <- pointerSensor { activationConstraints: [ dc, dl ] }
    ks <- keyboardSensor
      { offset: 15.0
      , keyboardCodes:
          { start: [ "Space", "Enter" ]
          , cancel: [ "Escape" ]
          , end: [ "Space", "Enter" ]
          , up: [ "ArrowUp" ]
          , down: [ "ArrowDown" ]
          , left: [ "ArrowLeft" ]
          , right: [ "ArrowRight" ]
          }
      }
    pure (ps /\ ks)
