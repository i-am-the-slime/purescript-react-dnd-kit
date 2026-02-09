module React.DndKit.Helpers
  ( move
  , swap
  , arrayMove
  , arraySwap
  ) where

import Foreign (Foreign)

-- | Reorder items based on a drag event.
-- | Works with flat arrays or grouped records.
-- | Use in onDragOver and onDragEnd handlers.
foreign import move :: Foreign -> Foreign -> Foreign

-- | Swap items based on a drag event.
-- | Works with flat arrays or grouped records.
foreign import swap :: Foreign -> Foreign -> Foreign

-- | Low-level array move: moves element from one index to another
foreign import arrayMove :: forall a. Array a -> Int -> Int -> Array a

-- | Low-level array swap: swaps elements at two indices
foreign import arraySwap :: forall a. Array a -> Int -> Int -> Array a
