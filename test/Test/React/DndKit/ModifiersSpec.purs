module Test.React.DndKit.ModifiersSpec where

import Prelude

import Effect.Class (liftEffect)
import React.DndKit.Modifiers (restrictToElement, restrictToHorizontalAxis, restrictToVerticalAxis, restrictToWindow, snap)
import Test.React.DndKit.Utils (defined)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Unsafe.Coerce (unsafeCoerce)

spec :: Spec Unit
spec = describe "modifiers" do
  it "restrictToVerticalAxis" do
    defined restrictToVerticalAxis `shouldEqual` true
  it "restrictToHorizontalAxis" do
    defined restrictToHorizontalAxis `shouldEqual` true
  it "restrictToWindow" do
    defined restrictToWindow `shouldEqual` true
  it "snap" do
    snapMod <- liftEffect $ snap { x: 20.0, y: 20.0 }
    defined snapMod `shouldEqual` true
  it "restrictToElement" do
    el <- liftEffect $ restrictToElement (unsafeCoerce unit)
    defined el `shouldEqual` true
