module Test.React.DndKit.Stories.MultiSelect.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.MultiSelect (multiSelect)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" multiSelect
  { selectedColor: color "#4f46e5"
  , targetColor: color "#065f46"
  , itemCount: 12
  , gridColumns: 4
  }
