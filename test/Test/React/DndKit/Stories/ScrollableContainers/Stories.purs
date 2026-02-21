module Test.React.DndKit.Stories.ScrollableContainers.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.ScrollableContainers (scrollableContainers)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" scrollableContainers
  { itemColor: color "#334155"
  , itemsPerColumn: 20
  , containerHeight: 400
  }
