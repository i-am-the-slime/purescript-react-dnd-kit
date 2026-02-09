module React.DndKit.Types
  ( Coordinates
  , CallbackRef
  , DraggableId(..)
  , DroppableId(..)
  , DragType(..)
  , FeedbackType
  , move
  , clone
  , noFeedback
  , Source
  , Target
  , DragOperationSnapshot
  , DragStartEvent
  , DragMoveEvent
  , DragOverEvent
  , DragEndEvent
  , CollisionEvent
  , DragDropManager
  , Collision
  , CollisionDetector
  , Sensor
  , Plugin
  , Modifier
  , DraggableInstance
  , DroppableInstance
  , SortableInstance
  , DndEffect
  ) where

import Prelude

import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Web.DOM (Element)
import Web.Event.Event (Event)

-- | 2D coordinates
type Coordinates = { x :: Number, y :: Number }

-- | Callback ref passed to DOM elements for dnd-kit to track them.
-- | Pass this as the `ref` prop on your DOM element.
foreign import data CallbackRef :: Type

newtype DraggableId = DraggableId String

derive instance Newtype DraggableId _
derive newtype instance Eq DraggableId
derive newtype instance Ord DraggableId
derive newtype instance Show DraggableId

newtype DroppableId = DroppableId String

derive instance Newtype DroppableId _
derive newtype instance Eq DroppableId
derive newtype instance Ord DroppableId
derive newtype instance Show DroppableId

-- | Matching type for draggables and droppables.
-- | Draggables with a given type can only be dropped on droppables that accept that type.
newtype DragType = DragType String

derive instance Newtype DragType _
derive newtype instance Eq DragType
derive newtype instance Ord DragType
derive newtype instance Show DragType

-- | Visual feedback strategy during drag.
newtype FeedbackType = FeedbackType String

derive newtype instance Eq FeedbackType
derive newtype instance Ord FeedbackType
derive newtype instance Show FeedbackType

move :: FeedbackType
move = FeedbackType "move"

clone :: FeedbackType
clone = FeedbackType "clone"

noFeedback :: FeedbackType
noFeedback = FeedbackType "none"

-- | Source entity in a drag operation
type Source =
  { id :: DraggableId
  , element :: Maybe Element
  }

-- | Target entity in a drag operation
type Target =
  { id :: DroppableId
  , element :: Maybe Element
  }

-- | Snapshot of the current drag operation, available on all events
type DragOperationSnapshot =
  { activatorEvent :: Maybe Event
  , canceled :: Boolean
  , position :: { current :: Coordinates, initial :: Coordinates }
  , transform :: Coordinates
  , source :: Maybe Source
  , target :: Maybe Target
  }

type DragStartEvent = { operation :: DragOperationSnapshot }

type DragMoveEvent =
  { operation :: DragOperationSnapshot
  , to :: Maybe Coordinates
  , by :: Maybe Coordinates
  }

type DragOverEvent = { operation :: DragOperationSnapshot }

type DragEndEvent =
  { operation :: DragOperationSnapshot
  , canceled :: Boolean
  }

type CollisionEvent = { collisions :: Array Collision }

-- | The central drag-drop manager (opaque)
foreign import data DragDropManager :: Type

-- | A collision result (opaque)
foreign import data Collision :: Type

-- | A collision detector function (opaque)
foreign import data CollisionDetector :: Type

-- | Sensor class or configured descriptor (opaque)
foreign import data Sensor :: Type

-- | Plugin class or configured descriptor (opaque)
foreign import data Plugin :: Type

-- | Modifier class or configured descriptor (opaque)
foreign import data Modifier :: Type

-- | Draggable instance (opaque)
foreign import data DraggableInstance :: Type

-- | Droppable instance (opaque)
foreign import data DroppableInstance :: Type

-- | Sortable instance (opaque)
foreign import data SortableInstance :: Type

-- | Reactive effect for advanced usage (opaque)
foreign import data DndEffect :: Type
