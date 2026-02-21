module Test.React.DndKit.Stories.MultiSelect.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.MultiSelect (multiSelect)
import Test.React.DndKit.Stories.ResetControl (resetControls)
import YogaStories.Story (story)

default :: JSX
default = story "default" multiSelect
  { itemCount: 12
  , gridColumns: 4
  , reset: resetControls
  }
