module Test.React.DndKit.Stories.PhotoGallery.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.PhotoGallery (photoGallery)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" photoGallery
  { thumbColor: color "#0d9488"
  , labelColor: color "#99f6e4"
  }
