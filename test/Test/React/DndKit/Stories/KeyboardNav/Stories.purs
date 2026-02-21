module Test.React.DndKit.Stories.KeyboardNav.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.KeyboardNav (keyboardNav)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" keyboardNav
  { itemColor: color "#4338ca"
  , activeColor: color "#7c3aed"
  }
