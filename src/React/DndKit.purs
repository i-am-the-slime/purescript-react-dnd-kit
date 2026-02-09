module React.DndKit
  ( dragDropProvider
  , DragDropProviderProps
  , dragOverlay
  , DragOverlayProps
  ) where

import Prelude

import Effect (Effect)
import Foreign (Foreign)
import Prim.Row as Row
import React.Basic (JSX, ReactComponent, element)
import React.DndKit.Internal (wrapHandlers_)
import React.DndKit.Types (CollisionEvent, DragDropManager, DragEndEvent, DragMoveEvent, DragOverEvent, DragStartEvent, Modifier, Plugin, Sensor)

type DragDropProviderProps =
  ( children :: Array JSX
  , manager :: DragDropManager
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

dragDropProvider :: forall props props_. Row.Union props props_ DragDropProviderProps => { | props } -> JSX
dragDropProvider props = element dragDropProviderImpl (wrapHandlers_ props)

type DragOverlayProps =
  ( children :: Array JSX
  , className :: String
  , style :: Foreign
  , tag :: String
  , disabled :: Boolean
  )

foreign import dragOverlayImpl :: forall props. ReactComponent { | props }

dragOverlay :: forall props props_. Row.Union props props_ DragOverlayProps => { | props } -> JSX
dragOverlay = element dragOverlayImpl
