import dotenv from 'dotenv';
import stream from "getstream";

dotenv.config();

exports.streamFeedCredentials = async (req, res) => {
  try {
    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;
    const appId = process.env.STREAM_APP_ID;

    const client = stream.connect(apiKey, apiSecret, appId);

    await client.user(req.user).getOrCreate({ name: req.user });
    const token = client.createUserToken(req.user);

    res.status(200).json({ token, apiKey, appId });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
};
