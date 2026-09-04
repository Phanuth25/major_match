import HistoryModel from "../../model/quiz/history_model.js";

export function history(req, res) {
  const { user_id } = req.params;

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
