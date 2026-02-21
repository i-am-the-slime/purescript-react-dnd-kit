module Test.React.DndKit.Stories.ShoppingCart.Stories where

import React.Basic (JSX)
import Test.React.DndKit.Stories.ShoppingCart (shoppingCart)
import YogaStories.Controls (color)
import YogaStories.Story (story)

default :: JSX
default = story "default" shoppingCart
  { productColor: color "#166534"
  , cartColor: color "#2563eb"
  }
