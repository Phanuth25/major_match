import SelectModel from "../../model/questions/select_model.js";

export function selectQuestionsByIds(req, res) {
  const { ids } = req.body;
  const scores = req.body.scores ?? {};

  if (!Array.isArray(ids) || ids.length === 0) {
    return res.status(400).json({
      message: "Question IDs are required",
    });
  }

  if (typeof scores !== "object" || Array.isArray(scores)) {
    return res.status(400).json({
      message: "Question scores are required",
    });
  }

  SelectModel.selectByIds(ids, (err, result) => {
    if (err) {
      console.error(err);

      return res.status(500).json({
        message: "Internal server error",
      });
    }

    if (result.length === 0) {
      return res.status(404).json({
        message: "Questions not found",
      });
    }

    const majorScores = {};

    for (const question of result) {
      const questionScore = Number(scores[question.id] ?? 0);
      majorScores[question.major_id] =
        (majorScores[question.major_id] ?? 0) + questionScore;
    }

    return res.status(200).json({
      message: "Questions retrieved successfully",
      questions: result,
      major_scores: majorScores,
    });
  });
}
