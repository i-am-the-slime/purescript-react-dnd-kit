module Test.React.DndKit.SensorsSpec where

import Prelude

import Effect.Class (liftEffect)
import React.DndKit.Sensors (delayConstraint, distanceConstraint, keyboardSensor, keyboardSensorDefault, pointerSensor, pointerSensorDefault)
import Test.React.DndKit.Utils (defined)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = describe "sensors" do
  it "pointerSensorDefault" do
    defined pointerSensorDefault `shouldEqual` true

  it "keyboardSensorDefault" do
    defined keyboardSensorDefault `shouldEqual` true

  it "pointerSensor with activationConstraints" do
    ps <- liftEffect do
      dc <- distanceConstraint { value: 10.0, tolerance: 5.0 }
      dl <- delayConstraint { value: 200.0, tolerance: 5.0 }
      pointerSensor { activationConstraints: [ dc, dl ] }
    defined ps `shouldEqual` true

  it "keyboardSensor with offset and keyboardCodes" do
    ks <- liftEffect $ keyboardSensor
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
    defined ks `shouldEqual` true

  it "distanceConstraint with value and tolerance" do
    dc <- liftEffect $ distanceConstraint { value: 10.0, tolerance: 5.0 }
    defined dc `shouldEqual` true

  it "delayConstraint with value and tolerance" do
    dl <- liftEffect $ delayConstraint { value: 200.0, tolerance: 5.0 }
    defined dl `shouldEqual` true
