module Test.React.DndKit.PluginsSpec where

import Prelude

import React.DndKit.Plugins (accessibility, autoScroller, cursor, feedback, preventSelection)
import Test.React.DndKit.Utils (defined)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = describe "plugins" do
  it "accessibility" do
    defined accessibility `shouldEqual` true
  it "autoScroller" do
    defined autoScroller `shouldEqual` true
  it "cursor" do
    defined cursor `shouldEqual` true
  it "feedback" do
    defined feedback `shouldEqual` true
  it "preventSelection" do
    defined preventSelection `shouldEqual` true
