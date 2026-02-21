module Test.React.DndKit.Stories.ScrollableContainers.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.ScrollableContainers (scrollableContainers)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" scrollableContainers
  { columnColor: color "#1e293b"
  , itemColor: color "#334155"
  , headerColor: color "#ffffff"
  }
