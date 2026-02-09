module React.DndKit.Modifiers
  ( restrictToVerticalAxis
  , restrictToHorizontalAxis
  , restrictToWindow
  , restrictToElement
  , snap
  , SnapConfig
  ) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import React.DndKit.Types (Modifier)
import Web.DOM (Element)

-- | Constrains movement to vertical axis only
foreign import restrictToVerticalAxis :: Modifier

-- | Constrains movement to horizontal axis only
foreign import restrictToHorizontalAxis :: Modifier

-- | Constrains movement within the viewport
foreign import restrictToWindow :: Modifier

-- | Constrains movement within a container element
foreign import restrictToElementImpl :: EffectFn1 Element Modifier

restrictToElement :: Element -> Effect Modifier
restrictToElement = runEffectFn1 restrictToElementImpl

-- | Snaps movement to a grid
type SnapConfig = { x :: Number, y :: Number }

foreign import snapImpl :: EffectFn1 SnapConfig Modifier

snap :: SnapConfig -> Effect Modifier
snap = runEffectFn1 snapImpl
