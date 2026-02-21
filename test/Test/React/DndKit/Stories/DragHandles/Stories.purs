module Test.React.DndKit.Stories.DragHandles.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.DragHandles (dragHandles)
import Test.React.DndKit.Stories.ResetControl (resetControls)
import YogaStories.Controls (select)
import YogaStories.Story (story)

default :: JSX
default = story "default" dragHandles
  { itemCount: 6
  , lockAxis: select "none" [ "none", "vertical", "horizontal" ]
  , reset: resetControls
  }
