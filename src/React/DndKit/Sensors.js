import { PointerSensor, KeyboardSensor, PointerActivationConstraints } from "@dnd-kit/dom";

export const pointerSensorDefault = PointerSensor;
export const pointerSensorConfigureImpl = (config) => PointerSensor.configure(config);

export const keyboardSensorDefault = KeyboardSensor;
export const keyboardSensorConfigureImpl = (config) => KeyboardSensor.configure(config);

export const distanceConstraintImpl = (config) => new PointerActivationConstraints.Distance(config);
export const delayConstraintImpl = (config) => new PointerActivationConstraints.Delay(config);
