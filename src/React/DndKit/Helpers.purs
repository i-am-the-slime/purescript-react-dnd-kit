module React.DndKit.Helpers
  ( move
  , swap
  , moveItems
  , swapItems
  , arrayMove
  , arraySwap
  ) where

import Foreign (Foreign)
import Unsafe.Coerce (unsafeCoerce)

-- | Reorder items based on a drag event.
-- | Works with flat arrays or grouped records.
-- | Use in onDragOver and onDragEnd handlers.
foreign import move :: Foreign -> Foreign -> Foreign

-- | Swap items based on a drag event.
-- | Works with flat arrays or grouped records.
foreign import swap :: Foreign -> Foreign -> Foreign

-- | Typed version of `move` for drag event handlers.
-- | Works with flat arrays or grouped records (e.g. kanban columns).
-- | Use in onDragOver or onDragEnd.
moveItems :: forall items event. items -> event -> items
moveItems items event = unsafeCoerce (move (unsafeCoerce items) (unsafeCoerce event))

-- | Typed version of `swap` for drag event handlers.
-- | Works with flat arrays or grouped records.
-- | Use in onDragOver or onDragEnd.
swapItems :: forall items event. items -> event -> items
swapItems items event = unsafeCoerce (swap (unsafeCoerce items) (unsafeCoerce event))

-- | Low-level array move: moves element from one index to another
foreign import arrayMove :: forall a. Array a -> Int -> Int -> Array a

-- | Low-level array swap: swaps elements at two indices
foreign import arraySwap :: forall a. Array a -> Int -> Int -> Array a
