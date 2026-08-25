import AttemptModel from "../../model/quiz/attempt_model.js";

export function attempt(req, res) {
  const { user_id, started_at, duration_second } = req.body;

  if (!user_id || !started_at || duration_second === undefined) {
    return res.status(400).json({
      message: "User ID, start time, and duration are required",
    });
  }

  const duration = Number(duration_second);

  if (!Number.isFinite(duration) || duration < 0) {
    return res.status(400).json({
      message: "Duration must be a non-negative number",
    });
  }

  AttemptModel.attempt(user_id, started_at, duration, (err, result) => {
    if (err) {
      console.error(err);

      return res.status(500).json({
        message: "Internal server error",
      });
    }

    return res.status(201).json({
      message: "Quiz attempt created successfully",
      attempt_id: result.insertId,
    });
  });
}
