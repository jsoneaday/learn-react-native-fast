import React from "react";
import {
  Image,
  StyleProp,
  StyleSheet,
  View,
  ViewStyle,
  ImageSourcePropType,
} from "react-native";
import { primary } from "../theme/colors";

interface AvatarProps {
  id?: string;
  imgFile: ImageSourcePropType;
  style?: StyleProp<ViewStyle>;
  size: number;
}

export default function Avatar({
  id,
  imgFile,
  style = {},
  size = 40,
}: AvatarProps) {
  return (
    <View
      style={{
        width: size,
        height: size,
        borderRadius: size / 2,
        ...styles.container,
        ...(style as object),
      }}
    >
      <Image source={imgFile} style={styles.img} resizeMode="cover" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    borderWidth: 2,
    borderColor: primary(),
    overflow: "hidden",
  },
  img: {
    width: "100%",
    height: "100%",
  },
});
