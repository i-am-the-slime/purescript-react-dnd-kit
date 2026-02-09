module React.DndKit.Internal where

import Data.Function.Uncurried (Fn2, runFn2)
import Data.Maybe (Maybe)
import Data.Nullable (Nullable, toMaybe)
import Foreign (Foreign)
import React.DndKit.Types (DragOperationSnapshot)

foreign import wrapHandlers :: forall a. Fn2 (Nullable Foreign -> Maybe Foreign) { | a } { | a }

wrapHandlers_ :: forall a. { | a } -> { | a }
wrapHandlers_ props = runFn2 wrapHandlers toMaybe props

foreign import convertOperationSnapshot :: Fn2 (Nullable Foreign -> Maybe Foreign) Foreign DragOperationSnapshot

convertOperationSnapshot_ :: Foreign -> DragOperationSnapshot
convertOperationSnapshot_ op = runFn2 convertOperationSnapshot toMaybe op
