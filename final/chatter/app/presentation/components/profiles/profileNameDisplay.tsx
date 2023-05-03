import { View, StyleSheet, Text } from "react-native";
import Avatar from "../avatar";
import { PrimaryButton } from "../buttons/buttons";
import { primary } from "../../theme/colors";
import {
  bodyFontStyle,
  subHeaderFontStyle,
} from "../../theme/element-styles/textStyles";
import { visibleBorder } from "../../theme/visibleBorder";
const profilePic = require("../../theme/assets/profile.jpeg");

export type ProfileNameDisplayData = {
  fullName: string;
  userName: string;
  avatar: Blob;
};

interface ProfileNameDisplayProps {
  profile: ProfileNameDisplayData;
}

export default function ProfileNameDisplay({
  profile,
}: ProfileNameDisplayProps) {
  return (
    <View style={styles.container}>
      <View style={styles.profileInfoContainer}>
        <Avatar imgFile={profilePic} size={50} />
        <View
          style={{
            marginLeft: 12,
            alignItems: "flex-start",
            justifyContent: "flex-start",
          }}
        >
          <Text style={{ ...subHeaderFontStyle() }}>{profile.fullName}</Text>
          <Text style={{ ...bodyFontStyle }}>{`@${profile.userName}`}</Text>
        </View>
      </View>
      <PrimaryButton
        containerStyle={styles.primaryBtnContainer}
        txtStyle={styles.primaryBtnTxt}
      >
        Add
      </PrimaryButton>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: "row",
    justifyContent: "space-between",
    marginBottom: 30,
  },
  profileInfoContainer: {
    flexDirection: "row",
    justifyContent: "flex-start",
  },
  primaryBtnContainer: {
    width: 110,
    paddingBottom: 15,
    paddingTop: 15,
    paddingRight: 25,
    paddingLeft: 25,
    borderRadius: 30,
    backgroundColor: primary(),
  },
  primaryBtnTxt: {
    ...subHeaderFontStyle(true),
  },
});
