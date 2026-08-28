import AttemptFinalModel from "../../model/quiz/attempt_final_model.js";

export function attemptFinal(req, res) {
  const { quiz_attempt_id, major_id, score } = req.body;

  if (!quiz_attempt_id || !major_id || score === undefined) {
    return res.status(400).json({
      message: "Quiz attempt ID, major ID, and score are required",
    });
  }

  const attemptId = Number(quiz_attempt_id);
  const majorId = Number(major_id);
  const finalScore = Number(score);

  if (
    !Number.isInteger(attemptId) ||
    attemptId < 1 ||
    !Number.isInteger(majorId) ||
    majorId < 1 ||
    !Number.isFinite(finalScore) ||
    finalScore < 0
  ) {
    return res.status(400).json({
      message: "Quiz attempt ID and major ID must be positive integers, and score must be non-negative",
    });
  }

  AttemptFinalModel.attemptFinal(
    attemptId,
    majorId,
    finalScore,
    (err, result) => {
      if (err) {
        console.error(err);

        return res.status(500).json({
          message: "Internal server error",
        });
      }

      return res.status(201).json({
        message: "Quiz final result created successfully",
        final_result_id: result.insertId,
      });
    },
  );
}
