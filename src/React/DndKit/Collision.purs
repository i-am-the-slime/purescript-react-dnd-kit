module React.DndKit.Collision
  ( defaultCollisionDetection
  , closestCenter
  , closestCorners
  , pointerIntersection
  , shapeIntersection
  , directionBiased
  , pointerDistance
  ) where

import React.DndKit.Types (CollisionDetector)

-- | Tries pointerIntersection, falls back to shapeIntersection
foreign import defaultCollisionDetection :: CollisionDetector

-- | Distance from droppable center to drag shape center
foreign import closestCenter :: CollisionDetector

-- | Sum of distances between corners
foreign import closestCorners :: CollisionDetector

-- | Checks if pointer is inside droppable shape
foreign import pointerIntersection :: CollisionDetector

-- | Intersection area between drag shape and droppable shape
foreign import shapeIntersection :: CollisionDetector

-- | Filters by drag direction, then uses closest
foreign import directionBiased :: CollisionDetector

-- | Distance from pointer to droppable center
foreign import pointerDistance :: CollisionDetector
