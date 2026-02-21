module Test.React.DndKit.Stories.FileManager.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.FileManager (fileManager)
import Test.React.DndKit.Stories.ResetControl (resetControls)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" fileManager
  { highlightColor: color "#1e3a5f"
  , indentSize: 24
  , reset: resetControls
  }
