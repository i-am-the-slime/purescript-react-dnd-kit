module Test.React.DndKit.Stories.MultiSelect.Styles where

import Yoga.React.DOM.Internal (CSS, css)

layoutStyle :: CSS
layoutStyle = css { maxWidth: "600px", margin: "0 auto", display: "flex", flexDirection: "column", gap: "20px" }

sectionStyle :: CSS
sectionStyle = css {}

labelStyle :: CSS
labelStyle = css { color: "white", fontSize: "14px", fontWeight: "600", marginBottom: "8px" }

gridStyle :: CSS
gridStyle = css
  { display: "grid"
  , gridTemplateColumns: "repeat(4, 1fr)"
  , gap: "8px"
  }

itemStyle :: String -> String -> CSS
itemStyle bg opacity = css
  { padding: "12px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , fontSize: "13px"
  , cursor: "pointer"
  , userSelect: "none"
  , opacity
  , display: "flex"
  , alignItems: "center"
  , gap: "8px"
  , transition: "background-color 200ms, opacity 200ms"
  }

checkStyle :: CSS
checkStyle = css { fontSize: "12px", width: "16px", textAlign: "center" }

targetStyle :: String -> String -> CSS
targetStyle bg border = css
  { backgroundColor: bg
  , border
  , borderRadius: "12px"
  , padding: "16px"
  , minHeight: "100px"
  , display: "flex"
  , flexWrap: "wrap"
  , gap: "8px"
  , transition: "background-color 200ms, border-color 200ms"
  }

targetItemStyle :: CSS
targetItemStyle = css
  { padding: "8px 12px"
  , backgroundColor: "#334155"
  , borderRadius: "6px"
  , color: "white"
  , fontSize: "13px"
  }

emptyStyle :: CSS
emptyStyle = css { color: "rgba(255,255,255,0.5)", fontSize: "14px", margin: "auto" }

overlayStyle :: String -> CSS
overlayStyle bg = css
  { backgroundColor: bg
  , borderRadius: "8px"
  , padding: "12px 20px"
  , color: "white"
  , fontSize: "14px"
  , fontWeight: "500"
  , boxShadow: "0 4px 12px rgba(0,0,0,0.3)"
  , display: "flex"
  , alignItems: "center"
  , gap: "8px"
  }

badgeStyle :: CSS
badgeStyle = css
  { backgroundColor: "rgba(255,255,255,0.25)"
  , borderRadius: "10px"
  , padding: "2px 8px"
  , fontSize: "12px"
  , fontWeight: "600"
  }
