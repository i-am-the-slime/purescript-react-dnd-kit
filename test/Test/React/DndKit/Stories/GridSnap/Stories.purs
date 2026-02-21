module Test.React.DndKit.Stories.GridSnap.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.GridSnap (gridSnap)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" gridSnap
  { tileColor: color "#7c3aed"
  , accentColor: color "#e9d5ff"
  }
