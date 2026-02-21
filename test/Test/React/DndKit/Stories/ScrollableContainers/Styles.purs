module Test.React.DndKit.Stories.ScrollableContainers.Styles where

import Yoga.React.DOM.Internal (CSS, css)

layoutStyle :: CSS
layoutStyle = css { display: "flex", gap: "16px", maxWidth: "700px", margin: "0 auto" }

columnStyle :: String -> CSS
columnStyle bg = css
  { flex: "1"
  , backgroundColor: bg
  , borderRadius: "12px"
  , display: "flex"
  , flexDirection: "column"
  }

headerStyle :: CSS
headerStyle = css
  { display: "flex"
  , justifyContent: "space-between"
  , alignItems: "center"
  , padding: "12px 16px"
  }

titleStyle :: String -> CSS
titleStyle col = css { color: col, fontSize: "14px", fontWeight: "600", margin: "0" }

countStyle :: CSS
countStyle = css
  { backgroundColor: "rgba(255,255,255,0.15)"
  , borderRadius: "10px"
  , padding: "2px 8px"
  , fontSize: "12px"
  , color: "rgba(255,255,255,0.7)"
  }

scrollAreaStyle :: Boolean -> CSS
scrollAreaStyle isTarget = css
  { overflowY: "auto"
  , height: "400px"
  , padding: "0 12px 12px"
  , display: "flex"
  , flexDirection: "column"
  , gap: "6px"
  , border: if isTarget then "2px solid rgba(255,255,255,0.3)" else "2px solid transparent"
  , borderRadius: "0 0 12px 12px"
  , transition: "border-color 200ms"
  }

itemStyle :: String -> String -> String -> CSS
itemStyle bg opacity cursor = css
  { padding: "10px 12px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "13px"
  , cursor
  , userSelect: "none"
  , opacity
  , display: "flex"
  , alignItems: "center"
  , gap: "8px"
  , boxShadow: "0 1px 3px rgba(0,0,0,0.2)"
  , transition: "opacity 200ms"
  }

handleStyle :: CSS
handleStyle = css { opacity: "0.5", fontSize: "12px" }
