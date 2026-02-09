module Test.React.DndKit.HelpersSpec where

import Prelude

import React.DndKit.Helpers (arrayMove, arraySwap)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = do
  describe "arrayMove" do
    it "moves element forward" do
      arrayMove [ "a", "b", "c" ] 0 2 `shouldEqual` [ "b", "c", "a" ]
    it "moves element backward" do
      arrayMove [ "a", "b", "c" ] 2 0 `shouldEqual` [ "c", "a", "b" ]
    it "same index is identity" do
      arrayMove [ 1, 2, 3 ] 1 1 `shouldEqual` [ 1, 2, 3 ]

  describe "arraySwap" do
    it "swaps two elements" do
      arraySwap [ "a", "b", "c" ] 0 2 `shouldEqual` [ "c", "b", "a" ]
    it "same index is identity" do
      arraySwap [ 1, 2, 3 ] 1 1 `shouldEqual` [ 1, 2, 3 ]
