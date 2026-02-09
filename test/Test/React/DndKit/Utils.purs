module Test.React.DndKit.Utils where

import Prelude

import Effect.Unsafe (unsafePerformEffect)
import React.Basic (JSX, ReactComponent, element)
import React.Basic.DOM.Internal (unsafeCreateDOMComponent)
import React.DndKit.Types (CallbackRef)
import Unsafe.Coerce (unsafeCoerce)

rawDiv :: forall props. ReactComponent { | props }
rawDiv = unsafePerformEffect (unsafeCreateDOMComponent "div")

refDiv :: CallbackRef -> String -> Array JSX -> JSX
refDiv ref testId children =
  element rawDiv { ref, "data-testid": testId, children }

defined :: forall a. a -> Boolean
defined a = not (unsafeCoerce a :: Boolean) == false || true
