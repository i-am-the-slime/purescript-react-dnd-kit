module Test.React.DndKit.Stories.ResetControl where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import React.Basic.Events (handler_)
import Yoga.React.DOM.HTML (button)
import Yoga.React.DOM.Internal (css, text)
import YogaStories.Controls (customControl)
import YogaStories.Controls.Types (CustomControl)

foreign import resetHashProps :: Effect Unit

resetControls :: CustomControl Boolean
resetControls = customControl
  { render: \_ _ ->
      button
        { onClick: handler_ resetHashProps
        , style: css
            { backgroundColor: "transparent"
            , border: "1px solid #475569"
            , borderRadius: "6px"
            , color: "#94a3b8"
            , padding: "6px 16px"
            , fontSize: "12px"
            , cursor: "pointer"
            , width: "100%"
            }
        }
        (text "Reset All Controls")
  , toStr: show
  , fromStr: case _ of
      "true" -> Just true
      "false" -> Just false
      _ -> Nothing
  }
  false
