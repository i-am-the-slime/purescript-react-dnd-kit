module Test.React.DndKit.Stories.ScrollableContainers.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.ScrollableContainers (scrollableContainers)
import YogaStories.Controls (select)
import YogaStories.Story (story)

default :: JSX
default = story "default" scrollableContainers
  { itemsPerColumn: 20
  , containerHeight: 400
  , feedback: select "clone" [ "clone", "move" ]
  }
