module Test.React.DndKit.Stories.GridSnap.Styles where

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "380px", margin: "0 auto" }

tileStyle :: String -> String -> String -> String -> CSS
tileStyle bg accent opacity cursor = css
  { width: "100px"
  , height: "100px"
  , backgroundColor: bg
  , borderRadius: "12px"
  , color: accent
  , fontSize: "24px"
  , fontWeight: "700"
  , display: "flex"
  , alignItems: "center"
  , justifyContent: "center"
  , cursor
  , opacity
  , userSelect: "none"
  , boxShadow: "0 2px 8px rgba(0,0,0,0.3)"
  , transition: "opacity 200ms"
  }
