module React.DndKit.Sensors
  ( pointerSensor
  , pointerSensorDefault
  , PointerSensorConfig
  , ActivationConstraint
  , keyboardSensor
  , keyboardSensorDefault
  , KeyboardSensorConfig
  , KeyboardCodes
  , DistanceConstraint
  , distanceConstraint
  , DelayConstraint
  , delayConstraint
  ) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row as Row
import React.DndKit.Types (Sensor)

foreign import pointerSensorDefault :: Sensor

type PointerSensorConfig =
  ( activationConstraints :: Array ActivationConstraint
  )

foreign import data ActivationConstraint :: Type

foreign import pointerSensorConfigureImpl :: forall config. EffectFn1 { | config } Sensor

pointerSensor :: forall config config_. Row.Union config config_ PointerSensorConfig => { | config } -> Effect Sensor
pointerSensor = runEffectFn1 pointerSensorConfigureImpl

-- | Distance-based activation constraint
type DistanceConstraint =
  ( value :: Number
  , tolerance :: Number
  )

foreign import distanceConstraintImpl :: forall config. EffectFn1 { | config } ActivationConstraint

distanceConstraint :: forall config config_. Row.Union config config_ DistanceConstraint => { | config } -> Effect ActivationConstraint
distanceConstraint = runEffectFn1 distanceConstraintImpl

-- | Delay-based activation constraint
type DelayConstraint =
  ( value :: Number
  , tolerance :: Number
  )

foreign import delayConstraintImpl :: forall config. EffectFn1 { | config } ActivationConstraint

delayConstraint :: forall config config_. Row.Union config config_ DelayConstraint => { | config } -> Effect ActivationConstraint
delayConstraint = runEffectFn1 delayConstraintImpl

-- | Keyboard sensor — enables keyboard navigation.
-- | Pass the class directly for default behavior, or configure it.
foreign import keyboardSensorDefault :: Sensor

type KeyboardCodes =
  { start :: Array String
  , cancel :: Array String
  , end :: Array String
  , up :: Array String
  , down :: Array String
  , left :: Array String
  , right :: Array String
  }

type KeyboardSensorConfig =
  ( offset :: Number
  , keyboardCodes :: KeyboardCodes
  )

foreign import keyboardSensorConfigureImpl :: forall config. EffectFn1 { | config } Sensor

keyboardSensor :: forall config config_. Row.Union config config_ KeyboardSensorConfig => { | config } -> Effect Sensor
keyboardSensor = runEffectFn1 keyboardSensorConfigureImpl
