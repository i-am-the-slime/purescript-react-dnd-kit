module Test.React.DndKit.HelpersSpec where

import Prelude

import Foreign (Foreign)
import React.DndKit.Helpers (arrayMove, arraySwap, move)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)
import Unsafe.Coerce (unsafeCoerce)

foreign import mockDragEvent :: String -> String -> Foreign
foreign import testRawHandlerDetection :: Unit -> Boolean
foreign import testRawHandlerCalled :: Unit -> Boolean
foreign import testMoveOnDragImplShape :: Unit -> Boolean
foreign import testMoveOnDragEndToEnd :: Unit -> Foreign

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

  describe "move (flat array)" do
    it "reorders items by id" do
      let items = asItems [ { id: "a" }, { id: "b" }, { id: "c" } ]
      let event = mockDragEvent "a" "c"
      let result = toIds (move items event)
      result `shouldEqual` [ "b", "c", "a" ]

  describe "move (grouped record)" do
    it "moves item between groups" do
      let items = asGrouped { left: [ { id: "a" }, { id: "b" } ], right: [ { id: "c" } ] }
      let event = mockDragEvent "a" "c"
      let result = toGroupedIds (move items event)
      result `shouldEqual` { left: [ "b" ], right: [ "a", "c" ] }

    it "moves item into empty group" do
      let items = asGrouped { left: [ { id: "a" }, { id: "b" } ], right: ([] :: Array { id :: String }) }
      let event = mockDragEvent "a" "right"
      let result = toGroupedIds (move items event)
      result `shouldEqual` { left: [ "b" ], right: [ "a" ] }

    it "moves item into empty group (3 columns)" do
      let items = asGrouped { todo: [ { id: "t1" } ], doing: [ { id: "t2" } ], done: ([] :: Array { id :: String }) }
      let event = mockDragEvent "t1" "done"
      let result = toGroupedIds3 (move items event)
      result `shouldEqual` { todo: [], doing: [ "t2" ], done: [ "t1" ] }

  describe "moveOnDrag (__rawHandler)" do
    it "wrapHandlers detects __rawHandler sentinel" do
      testRawHandlerDetection unit `shouldEqual` true
    it "wrapHandlers calls the raw handler with event and manager" do
      testRawHandlerCalled unit `shouldEqual` true
    it "moveOnDragImpl returns an object with __rawHandler" do
      testMoveOnDragImplShape unit `shouldEqual` true
    it "end-to-end: wrapHandlers + moveOnDragImpl reorders items" do
      let result = testMoveOnDragEndToEnd unit
      (unsafeCoerce result :: Boolean) `shouldEqual` true

  where
  asItems :: Array { id :: String } -> Foreign
  asItems = unsafeCoerce

  asGrouped :: forall r. { | r } -> Foreign
  asGrouped = unsafeCoerce

  toIds :: Foreign -> Array String
  toIds f = (unsafeCoerce f :: Array { id :: String }) <#> _.id

  toGroupedIds :: Foreign -> { left :: Array String, right :: Array String }
  toGroupedIds f = do
    let r = unsafeCoerce f :: { left :: Array { id :: String }, right :: Array { id :: String } }
    { left: r.left <#> _.id, right: r.right <#> _.id }

  toGroupedIds3 :: Foreign -> { todo :: Array String, doing :: Array String, done :: Array String }
  toGroupedIds3 f = do
    let r = unsafeCoerce f :: { todo :: Array { id :: String }, doing :: Array { id :: String }, done :: Array { id :: String } }
    { todo: r.todo <#> _.id, doing: r.doing <#> _.id, done: r.done <#> _.id }
