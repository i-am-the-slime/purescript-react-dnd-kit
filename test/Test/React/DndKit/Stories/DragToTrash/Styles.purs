module Test.React.DndKit.Stories.DragToTrash.Styles where

import Prelude

import Yoga.React.DOM.Internal (CSS, css)

containerStyle :: CSS
containerStyle = css { maxWidth: "500px", margin: "0 auto" }

gridStyle :: CSS
gridStyle = css { display: "flex", flexWrap: "wrap", gap: "10px", marginBottom: "20px" }

cardStyle :: String -> String -> String -> CSS
cardStyle bg opacity cursor = css
  { padding: "16px 20px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "14px"
  , fontWeight: "500"
  , cursor
  , opacity
  , userSelect: "none"
  , transition: "opacity 200ms"
  }

zoneStyle :: String -> String -> String -> Boolean -> CSS
zoneStyle bg border scale isActive = css
  { padding: "20px"
  , backgroundColor: bg
  , border
  , borderRadius: "12px"
  , textAlign: "center"
  , color: "white"
  , fontSize: "14px"
  , transition: "all 200ms"
  , transform: "scale(" <> scale <> ")"
  , opacity: if isActive then "1" else "0.5"
  }
