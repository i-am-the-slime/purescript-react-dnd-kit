module Test.React.DndKit.Stories.ShoppingCart.Styles where

import Yoga.React.DOM.Internal (CSS, css)

layoutStyle :: CSS
layoutStyle = css { display: "flex", gap: "24px", maxWidth: "700px", margin: "0 auto" }

catalogStyle :: CSS
catalogStyle = css
  { display: "grid"
  , gridTemplateColumns: "1fr 1fr"
  , gap: "10px"
  , flex: "1"
  }

productStyle :: String -> String -> String -> CSS
productStyle bg opacity cursor = css
  { padding: "12px 16px"
  , backgroundColor: bg
  , borderRadius: "8px"
  , color: "white"
  , cursor
  , opacity
  , userSelect: "none"
  , boxShadow: "0 1px 4px rgba(0,0,0,0.2)"
  , transition: "opacity 200ms"
  }

productNameStyle :: CSS
productNameStyle = css { fontSize: "14px", fontWeight: "600", marginBottom: "4px" }

productPriceStyle :: CSS
productPriceStyle = css { fontSize: "12px", opacity: "0.7" }

cartStyle :: String -> String -> CSS
cartStyle bg border = css
  { flex: "1"
  , backgroundColor: bg
  , border
  , borderRadius: "12px"
  , padding: "16px"
  , minHeight: "200px"
  , display: "flex"
  , flexDirection: "column"
  , transition: "all 200ms"
  }

cartHeaderStyle :: CSS
cartHeaderStyle = css
  { fontSize: "14px"
  , fontWeight: "600"
  , color: "white"
  , marginBottom: "12px"
  }

emptyCartStyle :: CSS
emptyCartStyle = css
  { flex: "1"
  , display: "flex"
  , alignItems: "center"
  , justifyContent: "center"
  , color: "rgba(255,255,255,0.5)"
  , fontSize: "13px"
  }

cartItemsStyle :: CSS
cartItemsStyle = css { display: "flex", flexDirection: "column", gap: "6px" }

cartItemStyle :: CSS
cartItemStyle = css
  { display: "flex"
  , justifyContent: "space-between"
  , padding: "8px 10px"
  , backgroundColor: "rgba(255,255,255,0.1)"
  , borderRadius: "6px"
  , fontSize: "13px"
  , color: "white"
  }

cartPriceStyle :: CSS
cartPriceStyle = css { opacity: "0.7", fontSize: "12px" }
