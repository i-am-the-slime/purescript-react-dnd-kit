module React.DndKit.Plugins
  ( accessibility
  , autoScroller
  , cursor
  , feedback
  , configureFeedback
  , FeedbackConfig
  , DropAnimation
  , noDropAnimation
  , preventSelection
  ) where

import Prim.Row as Row
import React.DndKit.Types (Plugin)

-- | Manages ARIA attributes for drag-drop operations
foreign import accessibility :: Plugin

-- | Auto-scrolls containers when dragging near edges
foreign import autoScroller :: Plugin

-- | Updates cursor styles during drag
foreign import cursor :: Plugin

-- | Manages visual feedback (move/clone/overlay) while dragging
foreign import feedback :: Plugin

foreign import data DropAnimation :: Type

-- | Disables the drop return animation.
-- | Use with `configureFeedback` to prevent items from flying back on drop.
foreign import noDropAnimation :: DropAnimation

type FeedbackConfig =
  ( dropAnimation :: DropAnimation
  )

foreign import configureFeedbackImpl :: forall config. { | config } -> Plugin

configureFeedback :: forall r r_. Row.Union r r_ FeedbackConfig => { | r } -> Plugin
configureFeedback = configureFeedbackImpl

-- | Prevents text selection while dragging
foreign import preventSelection :: Plugin
