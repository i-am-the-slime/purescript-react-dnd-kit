module Test.React.DndKit.CollisionSpec where

import Prelude

import React.DndKit.Collision (closestCenter, closestCorners, defaultCollisionDetection, directionBiased, pointerDistance, pointerIntersection, shapeIntersection)
import Test.React.DndKit.Utils (defined)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

spec :: Spec Unit
spec = describe "collision detectors" do
  it "defaultCollisionDetection" do
    defined defaultCollisionDetection `shouldEqual` true
  it "closestCenter" do
    defined closestCenter `shouldEqual` true
  it "closestCorners" do
    defined closestCorners `shouldEqual` true
  it "pointerIntersection" do
    defined pointerIntersection `shouldEqual` true
  it "shapeIntersection" do
    defined shapeIntersection `shouldEqual` true
  it "directionBiased" do
    defined directionBiased `shouldEqual` true
  it "pointerDistance" do
    defined pointerDistance `shouldEqual` true
