module Test.React.DndKit.Stories.DragHandles.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.DragHandles (dragHandles)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" dragHandles
  { itemColor: color "#334155"
  , accentColor: color "#6366f1"
  , itemCount: 5
  }
