module React.DndKit
  ( dragDropProvider
  , dragDropProvider_
  , DragDropProviderProps
  , dragOverlay
  , dragOverlay_
  , DragOverlayProps
  ) where

import Prelude

import Data.Function.Uncurried (Fn3, runFn3)
import Effect (Effect)
import Foreign (Foreign)
import Prim.Row as Row
import React.Basic (JSX, ReactComponent)
import React.DndKit.Internal (wrapHandlers_)
import React.DndKit.Types (class IsJSX, CollisionEvent, DragDropManager, DragEndEvent, DragMoveEvent, DragOverEvent, DragStartEvent, Modifier, Plugin, Sensor)

foreign import createElementImpl :: forall component props children. Fn3 component props children JSX

type DragDropProviderProps =
  ( manager :: DragDropManager
  , sensors :: Array Sensor
  , plugins :: Array Plugin
  , modifiers :: Array Modifier
  , onBeforeDragStart :: DragStartEvent -> DragDropManager -> Effect Unit
  , onDragStart :: DragStartEvent -> DragDropManager -> Effect Unit
  , onDragMove :: DragMoveEvent -> DragDropManager -> Effect Unit
  , onDragOver :: DragOverEvent -> DragDropManager -> Effect Unit
  , onCollision :: CollisionEvent -> DragDropManager -> Effect Unit
  , onDragEnd :: DragEndEvent -> DragDropManager -> Effect Unit
  )

foreign import dragDropProviderImpl :: forall props. ReactComponent { | props }

dragDropProvider
  :: forall jsx props props_
   . IsJSX jsx
  => Row.Union props props_ DragDropProviderProps
  => { | props }
  -> jsx
  -> JSX
dragDropProvider props children =
  runFn3 createElementImpl dragDropProviderImpl (wrapHandlers_ props) children

dragDropProvider_ :: forall jsx. IsJSX jsx => jsx -> JSX
dragDropProvider_ = dragDropProvider {}

type DragOverlayProps =
  ( className :: String
  , style :: Foreign
  , tag :: String
  , disabled :: Boolean
  )

foreign import dragOverlayImpl :: forall props. ReactComponent { | props }

dragOverlay
  :: forall jsx props props_
   . IsJSX jsx
  => Row.Union props props_ DragOverlayProps
  => { | props }
  -> jsx
  -> JSX
dragOverlay props children =
  runFn3 createElementImpl dragOverlayImpl props children

dragOverlay_ :: forall jsx. IsJSX jsx => jsx -> JSX
dragOverlay_ = dragOverlay {}
