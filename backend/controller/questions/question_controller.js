import QuestionModel from "../../model/questions/question_model.js";

export function getQuestionById(req, res) {
  const { id } = req.params;

  QuestionModel.selectById(id, (err, result) => {
    if (err) {
      console.error(err);

      return res.status(500).json({
        message: "Internal server error",
      });
    }

    if (result.length === 0) {
      return res.status(404).json({
        message: "Question does not exist",
      });
    }

    return res.status(200).json({
      message: "Question retrieved successfully",
      question: result,
    });
  });
}
