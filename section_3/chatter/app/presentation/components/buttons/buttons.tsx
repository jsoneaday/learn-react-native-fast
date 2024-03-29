import {
  GestureResponderEvent,
  Pressable,
  StyleSheet,
  Text,
} from "react-native";
import React, { ReactNode } from "react";
import { primary, secondary, tertiary } from "../../theme/colors";

export interface ButtonProps {
  children: ReactNode;
  containerStyle?: object;
  txtStyle?: object;
  onPress?: (event: GestureResponderEvent) => void;
  disabled?: boolean;
}

export function PrimaryButton({
  children,
  containerStyle = {},
  txtStyle = {},
  onPress,
  disabled = false,
}: ButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      style={{
        ...styles.primaryButtonStyle,
        ...containerStyle,
        opacity: !disabled ? 1 : 0.5,
      }}
      disabled={disabled}
    >
      <Text style={{ ...styles.txtPrimaryFont, ...txtStyle }}>{children}</Text>
    </Pressable>
  );
}

export function SecondaryButton({
  children,
  containerStyle = {},
  txtStyle = {},
  onPress,
  disabled = false,
}: ButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      style={{ ...containerStyle, opacity: !disabled ? 1 : 0.5 }}
      disabled={disabled}
    >
      <Text style={{ ...styles.txtSecondaryFont, ...txtStyle }}>
        {children}
      </Text>
    </Pressable>
  );
}

export function RingedButton({
  children,
  containerStyle = {},
  onPress,
}: ButtonProps) {
  return (
    <Pressable
      onPress={onPress}
      style={{ ...styles.dropDownButtonStyle, ...containerStyle }}
    >
      {children}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  primaryButtonStyle: {
    justifyContent: "center",
    backgroundColor: secondary(),
    borderRadius: 20,
    paddingLeft: 15,
    paddingRight: 15,
    paddingTop: 8,
    paddingBottom: 8,
  },
  txtPrimaryFont: {
    color: primary(true),
    fontSize: 14,
    textAlign: "center",
  },
  txtSecondaryFont: {
    color: primary(),
    fontSize: 14,
  },
  dropDownButtonStyle: {
    flexDirection: "row",
    alignItems: "center",
    justifyContent: "space-around",
    border: 1,
    borderWidth: 1,
    borderColor: tertiary(false, 0.5),
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: 4,
  },
});
