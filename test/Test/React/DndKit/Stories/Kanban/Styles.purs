module Test.React.DndKit.Stories.Kanban.Styles where

import Yoga.React.DOM.Internal (CSS, css)

boardStyle :: CSS
boardStyle = css { display: "flex", gap: "16px", padding: "16px", maxWidth: "900px", margin: "0 auto" }

columnStyle :: String -> Boolean -> CSS
columnStyle bg isTarget = css
  { flex: "1"
  , backgroundColor: if isTarget then brighten bg else bg
  , borderRadius: "12px"
  , padding: "12px"
  , minHeight: "300px"
  , display: "flex"
  , flexDirection: "column"
  , border: if isTarget then "2px solid rgba(255,255,255,0.3)" else "2px solid transparent"
  , transition: "background-color 200ms, border-color 200ms"
  }

headerStyle :: CSS
headerStyle = css
  { display: "flex"
  , justifyContent: "space-between"
  , alignItems: "center"
  , marginBottom: "12px"
  , padding: "0 4px"
  }

titleStyle :: String -> CSS
titleStyle col = css { margin: "0", color: col, fontSize: "14px", fontWeight: "600" }

countStyle :: CSS
countStyle = css
  { backgroundColor: "rgba(255,255,255,0.15)"
  , borderRadius: "10px"
  , padding: "2px 8px"
  , fontSize: "12px"
  , color: "rgba(255,255,255,0.7)"
  }

listStyle :: CSS
listStyle = css { display: "flex", flexDirection: "column", gap: "8px", flex: "1", minHeight: "60px" }

cardStyle :: String -> String -> CSS
cardStyle bg cursor = css
  { padding: "10px 12px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "13px"
  , cursor
  , userSelect: "none"
  , boxShadow: "0 1px 3px rgba(0,0,0,0.2)"
  }

-- Simple brightening by adding alpha overlay
foreign import brighten :: String -> String
