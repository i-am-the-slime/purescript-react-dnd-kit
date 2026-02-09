module React.DndKit.Hooks
  ( useDraggable
  , UseDraggable
  , UseDraggableConfig
  , UseDraggableResult
  , useDroppable
  , UseDroppable
  , UseDroppableConfig
  , UseDroppableResult
  , useDragDropMonitor
  , UseDragDropMonitor
  , UseDragDropMonitorConfig
  , useDragOperation
  , UseDragOperation
  ) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Foreign (Foreign)
import Prim.Row as Row
import React.Basic.Hooks.Internal (Hook, unsafeHook)
import React.DndKit.Internal (wrapHandlers_, convertOperationSnapshot_)
import React.DndKit.Types (CallbackRef, CollisionDetector, CollisionEvent, DragDropManager, DragEndEvent, DragMoveEvent, DragOperationSnapshot, DragOverEvent, DragStartEvent, DragType, DraggableId, DraggableInstance, DroppableId, DroppableInstance, FeedbackType, Modifier, Sensor)

-- useDraggable

type UseDraggableConfig a =
  ( id :: DraggableId
  , type :: DragType
  , disabled :: Boolean
  , feedback :: FeedbackType
  , modifiers :: Array Modifier
  , sensors :: Array Sensor
  , data :: a
  )

type UseDraggableResult =
  { ref :: CallbackRef
  , handleRef :: CallbackRef
  , isDragSource :: Boolean
  , isDragging :: Boolean
  , isDropping :: Boolean
  , draggable :: DraggableInstance
  }

foreign import data UseDraggable :: Type -> Type

foreign import useDraggableImpl :: forall config. EffectFn1 { | config } UseDraggableResult

useDraggable
  :: forall a config config_ rest
   . Row.Cons "id" DraggableId rest config
  => Row.Union config config_ (UseDraggableConfig a)
  => { | config }
  -> Hook UseDraggable UseDraggableResult
useDraggable config = unsafeHook (runEffectFn1 useDraggableImpl config)

-- useDroppable

type UseDroppableConfig a =
  ( id :: DroppableId
  , disabled :: Boolean
  , type :: DragType
  , collisionDetector :: CollisionDetector
  , collisionPriority :: Number
  , data :: a
  )

type UseDroppableResult =
  { ref :: CallbackRef
  , isDropTarget :: Boolean
  , droppable :: DroppableInstance
  }

foreign import data UseDroppable :: Type -> Type

foreign import useDroppableImpl :: forall config. EffectFn1 { | config } UseDroppableResult

useDroppable
  :: forall a config config_ rest
   . Row.Cons "id" DroppableId rest config
  => Row.Union config config_ (UseDroppableConfig a)
  => { | config }
  -> Hook UseDroppable UseDroppableResult
useDroppable config = unsafeHook (runEffectFn1 useDroppableImpl config)

-- useDragDropMonitor

type UseDragDropMonitorConfig =
  ( onBeforeDragStart :: DragStartEvent -> DragDropManager -> Effect Unit
  , onDragStart :: DragStartEvent -> DragDropManager -> Effect Unit
  , onDragMove :: DragMoveEvent -> DragDropManager -> Effect Unit
  , onDragOver :: DragOverEvent -> DragDropManager -> Effect Unit
  , onCollision :: CollisionEvent -> DragDropManager -> Effect Unit
  , onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
  )

foreign import data UseDragDropMonitor :: Type -> Type

foreign import useDragDropMonitorImpl :: forall config. EffectFn1 { | config } Unit

useDragDropMonitor
  :: forall config config_
   . Row.Union config config_ UseDragDropMonitorConfig
  => { | config }
  -> Hook UseDragDropMonitor Unit
useDragDropMonitor config = unsafeHook (runEffectFn1 useDragDropMonitorImpl (wrapHandlers_ config))

-- useDragOperation

foreign import data UseDragOperation :: Type -> Type

foreign import useDragOperationImpl :: Effect Foreign

useDragOperation :: Hook UseDragOperation DragOperationSnapshot
useDragOperation = unsafeHook (convertOperationSnapshot_ <$> useDragOperationImpl)
