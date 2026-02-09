module Test.React.DndKit.TypesSpec where

import Prelude

import Data.Newtype (un)
import React.DndKit.Sortable (SortableId(..))
import React.DndKit.Types (DraggableId(..), DroppableId(..))
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual, shouldNotEqual)

spec :: Spec Unit
spec = do
  describe "DraggableId" do
    it "Eq" do
      DraggableId "a" `shouldEqual` DraggableId "a"
      DraggableId "a" `shouldNotEqual` DraggableId "b"
    it "Ord" do
      compare (DraggableId "a") (DraggableId "b") `shouldEqual` LT
      compare (DraggableId "b") (DraggableId "a") `shouldEqual` GT
      compare (DraggableId "a") (DraggableId "a") `shouldEqual` EQ
    it "Show" do
      show (DraggableId "x") `shouldEqual` show "x"
    it "Newtype" do
      un DraggableId (DraggableId "test") `shouldEqual` "test"

  describe "DroppableId" do
    it "Eq" do
      DroppableId "a" `shouldEqual` DroppableId "a"
      DroppableId "a" `shouldNotEqual` DroppableId "b"
    it "Ord" do
      compare (DroppableId "a") (DroppableId "b") `shouldEqual` LT
      compare (DroppableId "b") (DroppableId "a") `shouldEqual` GT
      compare (DroppableId "a") (DroppableId "a") `shouldEqual` EQ
    it "Show" do
      show (DroppableId "x") `shouldEqual` show "x"
    it "Newtype" do
      un DroppableId (DroppableId "test") `shouldEqual` "test"

  describe "SortableId" do
    it "Eq" do
      SortableId "a" `shouldEqual` SortableId "a"
      SortableId "a" `shouldNotEqual` SortableId "b"
    it "Ord" do
      compare (SortableId "a") (SortableId "b") `shouldEqual` LT
      compare (SortableId "b") (SortableId "a") `shouldEqual` GT
      compare (SortableId "a") (SortableId "a") `shouldEqual` EQ
    it "Show" do
      show (SortableId "x") `shouldEqual` show "x"
    it "Newtype" do
      un SortableId (SortableId "test") `shouldEqual` "test"

  describe "id type safety" do
    it "DraggableId and DroppableId are distinct" do
      let _ = DraggableId "x"
      let _ = DroppableId "x"
      (un DraggableId (DraggableId "x")) `shouldEqual` (un DroppableId (DroppableId "x"))

    it "SortableId is distinct from DraggableId" do
      let _ = SortableId "x"
      let _ = DraggableId "x"
      (un SortableId (SortableId "x")) `shouldEqual` (un DraggableId (DraggableId "x"))
