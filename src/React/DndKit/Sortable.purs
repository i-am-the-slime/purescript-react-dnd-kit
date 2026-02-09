module React.DndKit.Sortable
  ( useSortable
  , UseSortable
  , UseSortableConfig
  , UseSortableResult
  , SortableTransition
  , SortableId(..)
  ) where

import Prelude

import Data.Newtype (class Newtype)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row as Row
import React.Basic.Hooks.Internal (Hook, unsafeHook)
import React.DndKit.Types (CallbackRef, CollisionDetector, Modifier, Sensor, SortableInstance)

newtype SortableId = SortableId String

derive instance Newtype SortableId _
derive newtype instance Eq SortableId
derive newtype instance Ord SortableId
derive newtype instance Show SortableId

type SortableTransition =
  { duration :: Number
  , easing :: String
  , idle :: Boolean
  }

type UseSortableConfig a =
  ( id :: SortableId
  , index :: Int
  , group :: String
  , type :: String
  , accept :: String
  , disabled :: Boolean
  , feedback :: String
  , modifiers :: Array Modifier
  , sensors :: Array Sensor
  , collisionDetector :: CollisionDetector
  , collisionPriority :: Number
  , transition :: SortableTransition
  , data :: a
  )

type UseSortableResult =
  { ref :: CallbackRef
  , handleRef :: CallbackRef
  , sourceRef :: CallbackRef
  , targetRef :: CallbackRef
  , isDropTarget :: Boolean
  , isDragSource :: Boolean
  , isDragging :: Boolean
  , isDropping :: Boolean
  , sortable :: SortableInstance
  }

foreign import data UseSortable :: Type -> Type

foreign import useSortableImpl :: forall config. EffectFn1 { | config } UseSortableResult

useSortable
  :: forall a config config_
   . Row.Union config config_ (UseSortableConfig a)
  => { | config }
  -> Hook UseSortable UseSortableResult
useSortable config = unsafeHook (runEffectFn1 useSortableImpl config)
