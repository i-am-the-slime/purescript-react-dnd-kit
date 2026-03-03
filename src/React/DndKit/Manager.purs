module React.DndKit.Manager
  ( setDragShape
  , updateDragShape
  , setGrabOffset
  , getGrabOffset
  , clearGrabOffset
  , getDragPosition
  ) where

import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import React.DndKit.Types (Coordinates, DragDropManager)
import Web.DOM (Element)

foreign import setDragShape :: DragDropManager -> Element -> Effect Unit
foreign import updateDragShape :: DragDropManager -> Number -> Number -> Number -> Number -> Effect Unit
foreign import setGrabOffset :: DragDropManager -> Number -> Number -> Effect Unit
foreign import getGrabOffset :: DragDropManager -> Effect (Nullable Coordinates)
foreign import clearGrabOffset :: DragDropManager -> Effect Unit
foreign import getDragPosition :: DragDropManager -> Effect (Nullable Coordinates)
