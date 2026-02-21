module Test.React.DndKit.Stories.FileManager.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.FileManager (fileManager)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" fileManager
  { folderColor: color "#1e293b"
  , fileColor: color "transparent"
  , dropHighlight: color "#1e3a5f"
  }
