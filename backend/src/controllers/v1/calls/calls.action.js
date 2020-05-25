let callsStorage = [];

exports.startCall = async (req, res) => {
	let call = {
		id: req.body.id,
		from: req.user,
		to: req.body.to
	};

	callsStorage.push(call);

	res.json(call);
};

exports.calls = async (req, res) => {
	res.json(
		callsStorage
			.filter(call => call.to === req.user)
	);
};

exports.endCall = async (req, res) => {
	callsStorage = callsStorage.filter(call => call.id !== req.params.id);
	res.json({ success: true });
};
