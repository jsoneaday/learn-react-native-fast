import ProfileShortModel from "./profile";

export default class MessageModel {
  constructor(
    public id: bigint,
    public updatedAt: string, // utc string later converted
    public body: string,
    public likes: number,
    public profile: {
      userName: string;
      fullName: string;
      avatar?: Blob;
    },
    public hasImage: boolean,
    public broadcastingMsg?: MessageModel,
    public responses?: number
  ) {}
}
