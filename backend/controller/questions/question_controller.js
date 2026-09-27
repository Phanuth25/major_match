import QuestionModel from "../../model/questions/question_model.js";

export function getQuestionById(req, res) {
  const { id, type } = req.params;
  console.log("Received request for question with id: %s and type: %s", id, type);

  QuestionModel.selectById(id, type, (err, result) => {
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

    res.status(200).json({
      message: "Question retrieved successfully",
      question: result,
    });
  });
}
