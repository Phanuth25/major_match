import HistoryModel from "../../model/quiz/history_model.js";

export function history(req, res) {
  console.log("req.params:", req.params); // Check what Express received
  const user_id = req.params.user_id || req.params.id;
  console.log("Extracted user_id:", user_id)

  if (!user_id) {
    return res.status(400).json({
      message: "User ID is required",
    });
  }

  HistoryModel.history(user_id, (err, result) => {
    if (err) {
      console.error(err);

      return res.status(500).json({
        message: "Internal server error ",
      });
    }
    return res.status(201).json({
      message: "Successfully",
      results: result,
    });
  });
}

export function removeHistory(req, res) {
  const { user_id, id } = req.params;
  HistoryModel.removeHistory(user_id, id, (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({
        message: "Internal server error ",
      });
    }

    return res.status(201).json({
      message: "Successfully",
      results: result,
    });
  });
}
