module React.DndKit.Plugins
  ( accessibility
  , autoScroller
  , cursor
  , feedback
  , preventSelection
  ) where

import React.DndKit.Types (Plugin)

-- | Manages ARIA attributes for drag-drop operations
foreign import accessibility :: Plugin

-- | Auto-scrolls containers when dragging near edges
foreign import autoScroller :: Plugin

-- | Updates cursor styles during drag
foreign import cursor :: Plugin

-- | Manages visual feedback (move/clone/overlay) while dragging
foreign import feedback :: Plugin

-- | Prevents text selection while dragging
foreign import preventSelection :: Plugin
