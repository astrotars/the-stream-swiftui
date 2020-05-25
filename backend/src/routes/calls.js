import { requireAuthHeader } from "../controllers/v1/users/users.action";
import { startCall, calls, endCall } from "../controllers/v1/calls/calls.action.js";
import { wrapAsync } from "../utils/controllers";

module.exports = api => {
	api.route("/v1/calls").post(requireAuthHeader, wrapAsync(startCall));
	api.route("/v1/calls").get(requireAuthHeader, wrapAsync(calls));
	api.route("/v1/calls/:id").delete(requireAuthHeader, wrapAsync(endCall));
};
